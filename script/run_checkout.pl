use strict;
use warnings;
use lib '../lib';
use ShoppingCart; 

my $pricing_data = ShoppingCart::load_pricing_data('../data/pricing_data.json');

my $scanned_items = ShoppingCart::load_scanning_items('../data/scanned_items.json');

my $subtotal = ShoppingCart::calculate_subtotal($scanned_items, $pricing_data);
print "Subtotal: $subtotal\n";