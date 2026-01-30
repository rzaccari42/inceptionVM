---
id: USER_DOC
aliases:
  - User Documentation
tags: []
---

# User Documentation
This project provides a secure WordPress website, ready to use through a web browser.

## Start and stop the project
- To start the WordPress website, Proxy server and database services use `make up`. After a few seconds, the website becomes available at `https://<login>.42.fr`.
- To stop the website temporarly (preserved data) use `make down`.
- If the website does not behave as expected, restarting the stack with `make restart` may fix the issue.

Starting or stopping the project does not delete website data, all content and user accounts are preserved.

## Access the administrator panel
Open `https://<login>.42.fr/wp-admin` or `https://<login>.42.fr/wp-login.php`

With the administrator credentials provided during the project setup, you can:
- Create and edit pages and posts
- Manage users and roles
- Upload media files
- Configure site settings

## Locate and manage credentials
Website credentials are managed outside of the WordPress interface for security reasons.
They are defined when the project is deployed and are located at the root of the project in the `./secrets` directory.  
 
**The project uses several types of credentials:**
- WordPress administrator credentials
    - Used to log in to the admin panel
    - Allows full control of the website
- WordPress user credentials
    - Used by editors, authors, or contributors
    - Managed through the WordPress admin interface
- Database credentials
    - Used internally by the system
    - Not required for normal website usage

## Check that the services are running correctly
This section explains how to verify that the website is working as expected from a user or administrator point of view.
To ensure all services containers are running use `make ps` or `docker ps`. Output should display all services exactrly as follows:
```
CONTAINER ID   IMAGE       COMMAND                  CREATED          STATUS          PORTS                                     NAMES
d69795dcdd79   nginx       "/usr/local/bin/entr…"   13 seconds ago   Up 12 seconds   0.0.0.0:443->443/tcp, [::]:443->443/tcp   nginx
58b823816697   wordpress   "entrypoint.sh php-f…"   13 seconds ago   Up 6 seconds    9000/tcp                                  wordpress
45f24c8c3f73   mariadb     "entrypoint.sh maria…"   13 seconds ago   Up 13 seconds   3306/tcp                                  mariadb
```

**Website availability**
Open a web browser and go to: `https://<login>.42.fr`
If the homepage loads correctly and image and content are displayed, the website service is running properly.

**Database and modification persistance**
Step 1: Make a visible change
- Log in to the WordPress admin panel: `https://<login>.42.fr/wp-admin`
- Go to Pages or Posts
- Edit an existing page (or create a new one)
- Add a short text (for example: “Persistence test”)
- Click Update or Publish
Step 2: Verify the change
- Open the public website: `https://<login>.42.fr`
- Navigate to the modified page
✅ The change should be visible immediately.
Step 3: Restart the project
- Restart the infrastructure: `make restart`
- Wait a few seconds until the services are running again
Step 4: Verify persistence
- Reload the website page in your browser
- Log back into the admin panel if needed
✅ If the text you added is still present, data persistence is working correctly.

**Security protocol**
To ensure data transit is encrypted and website securised :
- Open website in a browser, the site must start with `https://`
- Check the browser security indicator: a lock icon should be visible, click on it to view connection security details.


