from tkinter import * 
from tkinter import messagebox
import tkinter as tk
import psycopg2

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

def prikazi_proizvode():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT naziv_proizvoda, cijena FROM projekt.proizvod;")

    rows = cur.fetchall()

    tekst.delete("1.0", tk.END)
    for r in rows:
        tekst.insert(tk.END, f"{r[0]} - {r[1]} KM\n")

    cur.close()
    conn.close()

def najvise_narucivani():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
                SELECT p.naziv_proizvoda, SUM(sn.kolicina) AS ukupno
        FROM projekt.proizvod p
        JOIN projekt.stavka_narudzbe sn ON p.proizvod_id = sn.proizvod_id
        GROUP BY p.naziv_proizvoda
        HAVING SUM(sn.kolicina) > 2
        ORDER BY ukupno DESC;
                """)
    
    rows = cur.fetchall()

    tekst.delete("1.0", tk.END)

    tekst.insert(tk.END, f"{'Proizvod':<25} {'Broj narudžbi':<15}\n")
    tekst.insert(tk.END, "-" * 40 + "\n")

    for r in rows:
        tekst.insert(tk.END, f"{r[0]:<25} {r[1]:<15}\n")



window = Tk()
window.geometry("500x400")
window.title("FORMA 1 - Prikaz proizvoda ")
window.config(background="grey")


btn1 = Button(window, text="Prikaži sve proizvode", command=prikazi_proizvode)
btn1.config(bg="#0d455e")
btn1.config(fg="white")
btn1.pack(pady=5)

btn2 = Button(window, text="Najviše naručivani proizvodi", command=najvise_narucivani)
btn2.config(bg="#0d455e")
btn2.config(fg="white")
btn2.pack(pady=5)

tekst = tk.Text(window, height=20, width=60)
tekst.pack(pady=10)


window.mainloop()