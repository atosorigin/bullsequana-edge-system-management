DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': "mism",
        'USER': "mism",
        'PASSWORD': "mismpass",
        'HOST': "awx_postgres",
        'PORT': "5432",
    }
}

BROKER_URL = 'amqp://{}:{}@{}:{}/{}'.format(
    "mism",
    "mismpass",
    "rabbitmq",
    "5672",
    "awx")

CHANNEL_LAYERS = {
    'default': {'BACKEND': 'asgi_amqp.AMQPChannelLayer',
                'ROUTING': 'awx.main.routing.channel_routing',
                'CONFIG': {'url': BROKER_URL}}
}

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '{}:{}'.format("memcached", "11211")
    },
    'ephemeral': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    },
}
