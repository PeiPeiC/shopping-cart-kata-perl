use strict;
use warnings;
use Test::More; 
use lib './lib';
use ShoppingCart;

# test1: valid special price string
my $special_price = ShoppingCart::parse_special_price("3 for 75");
is_deeply($special_price, { quantity => 3, price => 75 }, 'Test1: Parse valid special price string');

# test2: return undef for invalid special price format
is(ShoppingCart::parse_special_price("invalid format"), undef, 'Test2: Invalid special price format should return undef');

# test 3: return undef for empty string
is(ShoppingCart::parse_special_price(""), undef, 'Test3: Empty string should return undef');

done_testing();
