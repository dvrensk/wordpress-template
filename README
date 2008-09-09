# WordPress template

`wordpress-template` is basically a Rake script to create a zip file
that works as a one-click installer for new WordPress projects.

## Creating the one-click installer

Clone this project to your own computer. Enter the top directory and run
`rake`. This will create `nytt_wp-projekt.zip` in the `build` directory.
Store the zip file in a safe place or mail it to the intended user.

## Using the one-click installer

Extract the zip file in your project directory (I'm assuming
`~/Projects` here). This will create `~/Projects/projektnamn`. Rename
the directory to the name of your project. Double click the file
`double_click_to_install` and follow the instructions.

### What the installer does

The installer does a number of things after asking you for the relevant
details:

1. Creates a database for your project.
2. Creates `wp-config.php` which tells WP where the database is and
    what language to use (Swedish).
3. Adds *projectname*.*computername*.local as an alias for localhost
    in `/etc/hosts`.
4. Adds a vhost entry in `/etc/apache2/users/#{username}.conf` for this
    WP project.
5. Creates a .htaccess in the wordpress root so that you are ready to
    use good-looking permalinks even in development.
6. Stores the pristine project in git.

The project also contains a [Capistrano][] `deploy.rb` that you can use
(with very little configuration) to deploy your project to the
production server.

## Requirements

To use the one-click installer you need the following:

1. Apache with PHP and vhosts (see separate blog post).
2. A MySQL server where the MySQL user `root` can create a database.
3. The password for the MySQL user `root`.
4. An account that can `sudo`.

## Bugs / limitations

1. The instructions in the installer are in Swedish at the moment. If
    you would like to see them in another language, just let me know.
2. The WordPress project will use Swedish for the admin interface.
3. The script has only been tested on OS X 10.5 Leopard.

Patches are welcome.

## History

I created the one-click installer in August 2008 to scratch a very
specific itch: to make it easy for a web designer to create new
WordPress projects without going through a lot of hoops.

The project has been updated to WordPress 2.6.2.

## Author

David Vrensk -- <http://www.vrensk.com/>

## Resources

[WordPress]: http://www.wordpress.org/
[Capistrano]: http://www.capify.org/
