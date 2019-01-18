FROM jupyterhub/jupyterhub

MAINTAINER Andrew Jackson <Andrew.Jackson@bl.uk>

# We need to update pip, otherwise the version of requests that
# is installed by dockerspawner breaks things.
RUN pip install --upgrade pip

# Install dockerspawner and oauthenticator
RUN pip install dockerspawner oauthenticator

# Install psycopg2
RUN apt-get update
RUN apt-get -y install libpq-dev
RUN pip install psycopg2

# add the userlist, spawner, and authenticator
RUN mkdir /srv/jupyterhub_config
WORKDIR /srv/jupyterhub_config
ADD systemuserspawner.py /srv/jupyterhub_config/systemuserspawner.py
ADD docker_oauth.py /srv/jupyterhub_config/docker_oauth.py
ADD jupyterhub_config.py /srv/jupyterhub_config/jupyterhub_config.py

# create /srv/jupyterhub_users directory (which is where we'll mount the userlist)
RUN mkdir /srv/jupyterhub_users

# we need to expose ports for the hub api and for the proxy api
EXPOSE 8080
EXPOSE 8001

# run jupyterhub
ENTRYPOINT ["jupyterhub", "-f", "/srv/jupyterhub_config/jupyterhub_config.py"]
