import os
from Crypto.Cipher import AES
from Crypto.Random import new as Random
from hashlib import sha256
from base64 import b64encode,b64decode

class AESCipher:
  def __init__(self,data):
    if os.path.exists('/etc/zabbix/zabbix_agentd.psk'):
      with open('/etc/zabbix/zabbix_agentd.psk', 'r') as psk_file:
        self.key = psk_file.read()
    if not self.key:
      return
    self.block_size = 16
    self.data = data
    self.key = sha256(self.key.encode()).digest()[:32]
    self.pad = lambda s: s + (self.block_size - len(s) % self.block_size) * chr (self.block_size - len(s) % self.block_size)
    self.unpad = lambda s: s[:-ord(s[len(s) - 1:])]

  def encrypt(self):
    if not self.key:
      return None
    plain_text = self.pad(self.data)
    iv = Random().read(AES.block_size)
    cipher = AES.new(self.key,AES.MODE_OFB,iv)
    return b64encode(iv + cipher.encrypt(plain_text.encode())).decode()

  def decrypt(self):
    if not self.key:
      return None
    cipher_text = b64decode(self.data.encode())
    iv = cipher_text[:self.block_size]
    cipher = AES.new(self.key,AES.MODE_OFB,iv)
    return self.unpad(cipher.decrypt(cipher_text[self.block_size:])).decode()
