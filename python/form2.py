import psycopg2
import tkinter as tk
from tkinter import messagebox
from tkinter import *


def get_connection():
    try:
        conn = psycopg2.connect(
             host="localhost",
            port="5432",
            database="YOUR_DATABASE",
            user="YOUR_USERNAME",
            password="YOUR_PASSWORD"
        )
        return conn
    except Exception as e:
        messagebox.showerror("Greška", str(e))


# funkcija za dodavanje narudzbe

def dodaj_narudzbu():
    kupac = entry_kupac.get()
    zaposlenik = entry_zaposlenik.get()
    iznos = entry_iznos.get()
    status = entry_status.get()

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO projekt.narudzba (kupac_id, zaposlenik_id, iznos_narudzbe, status, datum_narudzbe)
        VALUES (%s, %s, %s, %s, CURRENT_DATE)
        RETURNING narudzba_id;
                """, (kupac, zaposlenik, iznos, status))
    
    new_id = cur.fetchone()[0]
    conn.commit()

    tekst.insert(tk.END, f"Nova narudžba kreirana! ID: {new_id}\n")

    cur.close()
    conn.close()


# dodavanje stavke narudzbe (aktivira triger smanji skladiste)

def dodaj_stavku():
    narudzba = entry_narudzba_id.get()
    proizvod = entry_proizvod.get()
    kolicina = entry_kolicina.get()

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
            INSERT INTO projekt.stavka_narudzbe (narudzba_id, proizvod_id, kolicina)
                VALUES (%s, %s, %s);
                """, (narudzba, proizvod, kolicina))
    
    conn.commit()

    tekst.insert(tk.END, f"Stavka dodana za narudžbu {narudzba}.\n")
    tekst.insert(tk.END, "Trigger: skladište automatski ažurirano!\n\n")

    cur.close()
    conn.close()

# promjena statusa narudzbe (aktivira triger za kreiranje racuna)

def promijeni_status():
    narudzba = entry_promjena_id.get()
    novi = entry_novi_status.get()

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
            UPDATE projekt.narudzba
            SET status = %s
            WHERE narudzba_id = %s;
                """, (novi, narudzba))
    
    conn.commit()

    tekst.insert(tk.END, f"Status narudžbe {narudzba} promijenjen u {novi}.\n")

    tekst.insert(tk.END, "Trigger: automatski kreiran račun")

    cur.close()
    conn.close()


window = tk.Tk()
window.geometry("600x900")
window.title("FORMA 2 - Rad s narudžbama ")


tk.Label(window, text="Dodavanje narudžbe", font=("Arial", 14, "bold", "italic")).pack(pady=(25,5))

tk.Label(window, text="Kupac ID:").pack()
entry_kupac = tk.Entry(window)
entry_kupac.pack()


tk.Label(window, text="Zaposlenik ID:").pack()
entry_zaposlenik = tk.Entry(window)
entry_zaposlenik.pack()

tk.Label(window, text="Iznos narudžbe:").pack()
entry_iznos = tk.Entry(window)
entry_iznos.pack()

tk.Label(window, text="Status narudžbe:").pack()
entry_status = tk.Entry(window)
entry_status.pack()


btn_narudzba = tk.Button(window, text="Dodaj narudžbu", command=dodaj_narudzbu)
btn_narudzba.pack(pady=10)
btn_narudzba.config(bg="#0d455e")
btn_narudzba.config(fg="white")

tk.Frame(window, height=2, bg="lightgrey").pack(fill="x",pady=(10,0))
tk.Label(window, text="Dodavanje stavke narudžbe", font=("Arial", 14, "bold", "italic")).pack(pady=(25,5))

tk.Label(window, text="Narudžba ID:").pack()
entry_narudzba_id = tk.Entry(window)
entry_narudzba_id.pack()

tk.Label(window, text="Proizvod ID:").pack()
entry_proizvod = tk.Entry(window)
entry_proizvod.pack()

tk.Label(window, text="Količina:").pack()
entry_kolicina = tk.Entry(window)
entry_kolicina.pack()

btn_stavka = tk.Button(window, text="Dodaj stavku", command=dodaj_stavku)
btn_stavka.pack(pady=10)
btn_stavka.config(bg="#0d455e")
btn_stavka.config(fg="white")

tk.Frame(window, height=2, bg="lightgrey").pack(fill="x",pady=(10,0))

tk.Label(window, text="Promjena statusa narudžbe", font=("Arial", 14, "bold", "italic")).pack(pady=(25,5))

tk.Label(window, text="ID narudžbe").pack()
entry_promjena_id = tk.Entry(window)
entry_promjena_id.pack()

tk.Label(window, text="Status (isporučena/završena)").pack()
entry_novi_status = tk.Entry(window)
entry_novi_status.pack()


btn_status= tk.Button(window, text="Promijeni status", command=promijeni_status)
btn_status.pack(pady=10)
btn_status.config(bg="#0d455e")
btn_status.config(fg="white")


tekst = tk.Text(window, height=15, width=70)
tekst.pack(pady=20)

window.mainloop()