docker stop vault-ui
docker rm vault-ui

docker run -d \
    -p 8000:8000 \
    --name vault-ui \
    -e VAULT_URL_DEFAULT=https://vault.kotify.net \
    -e VAULT_AUTH_DEFAULT=USERNAMEPASSWORD \
    djenriquez/vault-ui


