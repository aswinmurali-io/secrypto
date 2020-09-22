from setuptools import setup

setup(
    name='Secrypto',
    packages=['secrypto'],
    include_package_data=True,
    install_requires=open('requirements.txt').read().split('\n')
)
