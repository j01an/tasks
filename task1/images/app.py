from flask import Flask, request
import subprocess 
import os
app = Flask(__name__)


@app.route('/')
def home():
    return "rogger"


@app.route('/greetings')
def gretings():
    outpout = os.getenv("HOSTNAME")
    #print(jl)
    #args = ["hostname"]
    #send=subprocess.Popen(args, stdout=subprocess.PIPE, text=True)
    #outpout, error= send.communicate()
    return f"hola mundo de {outpout}"

@app.route('/square')
def square():
    x = request.args.get("valor")
    valor = int(x)**2
    return f"el cuadrado de X es: {valor}"


