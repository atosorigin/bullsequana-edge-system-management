import pika

parameters = pika.URLParameters("amqp://guest:awxpass@rabbitmq:5672/awx")

connection = pika.BlockingConnection(parameters)
channel = connection.channel()
channel.basic_publish(queue='awx', routing_key='awx',
                      body=b'Test message.')
connection.close()