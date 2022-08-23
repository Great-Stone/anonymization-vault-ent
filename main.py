from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
import requests, json, base64
from urllib import parse

vault_addr = "http://127.0.0.1:8200"
headers = {
    'X-Vault-Token': 'root'
}

app = FastAPI()

@app.get("/name/{org}")
async def fpe_name(org):
  unquotname = parse.unquote(org)
  print(unquotname)
  data = {
    'value': unquotname,
    'transformation': 'kr-name'
  }
  res = requests.post(f"{vault_addr}/v1/transform/encode/customer", headers=headers, data=data)
  enc = json.loads(res.text)['data']['encoded_value']
  print(enc)
  return enc

@app.get("/name-dec/{org}")
async def fpe_name_dec(org):
  unquotname = parse.unquote(org)
  print(unquotname)
  data = {
    'value': unquotname,
    'transformation': 'kr-name'
  }
  res = requests.post(f"{vault_addr}/v1/transform/decode/customer", headers=headers, data=data)
  enc = json.loads(res.text)['data']['decoded_value']
  print(enc)
  return enc

@app.get("/ssn/{org}")
async def masking_ssn(org):
  print(org)
  data = {
    'value': org,
    'transformation': 'resident-registration-number'
  }
  res = requests.post(f"{vault_addr}/v1/transform/encode/privacy", headers=headers, data=data)
  enc = json.loads(res.text)['data']['encoded_value']
  print(enc)
  return enc

@app.get("/phone/{org}")
async def fpe_phone(org):
  print(org)
  data = {
    'value': org,
    'transformation': 'phone-number'
  }
  res = requests.post(f"{vault_addr}/v1/transform/encode/privacy", headers=headers, data=data)
  enc = json.loads(res.text)['data']['encoded_value']
  print(enc)
  return enc

@app.get("/phone-dec/{org}")
async def fpe_phone_dec(org):
  print(org)
  data = {
    'value': org,
    'transformation': 'phone-number'
  }
  res = requests.post(f"{vault_addr}/v1/transform/decode/privacy", headers=headers, data=data)
  enc = json.loads(res.text)['data']['decoded_value']
  print(enc)
  return enc

@app.get("/encrypt/{org}")
async def encrypt(org):
  print(org)
  data = {
    'plaintext': base64.b64encode(org.encode('ascii'))
  }
  res = requests.post(f"{vault_addr}/v1/transit/encrypt/aes256", headers=headers, data=data)
  enc = json.loads(res.text)['data']['ciphertext']
  print(enc)
  return enc

@app.get("/decrypt/{org}")
async def decrypt(org):
  print(org)
  data = {
    'ciphertext': base64.b64decode(org)
  }
  res = requests.post(f"{vault_addr}/v1/transit/decrypt/aes256", headers=headers, data=data)
  decbase64 = json.loads(res.text)['data']['plaintext']
  dec = base64.b64decode(decbase64).decode('ascii')
  print(dec)
  return dec

@app.get("/tokenization")
async def tokenization(cardno, cardtype):
  print(cardno, cardtype)
  data = {
    'value': cardno,
    'transformation': 'credit-card',
    'ttl': '8h',
    'metadata': f"Type={cardtype}"
  }
  res = requests.post(f"{vault_addr}/v1/transform/encode/mobile-pay", headers=headers, data=data)
  enc = json.loads(res.text)['data']['encoded_value']
  print(enc)
  return enc

@app.get("/tokenvalidate/{token}")
async def tokenmeta(token):
  print(token)
  data = {
    'value': token,
    'transformation': 'credit-card'
  }
  res = requests.post(f"{vault_addr}/v1/transform/validate/mobile-pay", headers=headers, data=data)
  enc = json.loads(res.text)['data']['valid']
  print(enc)
  return enc

@app.get("/tokenmeta/{token}")
async def tokenmeta(token):
  print(token)
  data = {
    'value': token,
    'transformation': 'credit-card'
  }
  res = requests.post(f"{vault_addr}/v1/transform/metadata/mobile-pay", headers=headers, data=data)
  enc = json.loads(res.text)['data']
  print(enc)
  return enc

app.mount("/", StaticFiles(directory="static", html = True), name="static")