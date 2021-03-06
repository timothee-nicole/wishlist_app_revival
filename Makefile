
GITHUB_IO_PATH=~/github/robinicole.github.io/wishlist_app
build:
	docker-compose build

prettify_frontend:
	cd frontend/src/ prettier --write .
run: build
	docker-compose up

local_backend:
	cd backend/wishlist && pipenv run python manage.py runserver 

send_to_github_io:
	cd frontend && SKIP_PREFLIGHT_CHECK=true npm run build 
	cp -rf frontend/build/* $(GITHUB_IO_PATH)
	cd $(GITHUB_IO_PATH) && git add --all && git commit -m 'update-react-app'

push_to_github_io:
	cd $(GITHUB_IO_PATH) && git push

deploy_frontend: send_to_github_io push_to_github_io

deploy_backend:
	git push heroku `git subtree split --prefix backend  master`:master --force

deploy: deploy_frontend deploy_backend

test_backend:
	cd backend/wishlist/ && pipenv run python manage.py test