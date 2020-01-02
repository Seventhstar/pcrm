bundle exec rake assets:precompile
kill -QUIT `cat /var/run/unicorn/hosting_polinov/crmpp.polinov.pid`
bundle exec unicorn_rails -Dc /etc/unicorn/crmpp.polinov.rb
bundle exec rake assets:clean