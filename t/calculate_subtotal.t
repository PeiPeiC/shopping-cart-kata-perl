use strict;
use warnings;
use Test::More; 
use lib './lib';
use ShoppingCart;


# test1: no special price
my $scanned_items1 = [
    { code => 'A', quantity => 1 },
    { code => 'B', quantity => 2 },
];

my $pricing_rules1 = [
    { item_code => 'A', unit_price => 50 },
    { item_code => 'B', unit_price => 30 },
];

is(ShoppingCart::calculate_subtotal($scanned_items1, $pricing_rules1), 110, 'Test1: Subtotal without special price');

# test2 : include special price
my $scanned_items2 = [
    { code => 'A', quantity => 3 },  # 3 for 130
    { code => 'B', quantity => 2 },
];

my $pricing_rules2 = [
    { item_code => 'A', unit_price => 50, special_price => { quantity => 3, price => 130 } },
    { item_code => 'B', unit_price => 30 },
];

is(ShoppingCart::calculate_subtotal($scanned_items2, $pricing_rules2), 190, 'Test2: Subtotal with special price applied');

# test3: Item not found
my $scanned_items3 = [
    { code => 'C', quantity => 1 },
];

my $error;
eval {
    ShoppingCart::calculate_subtotal($scanned_items3, $pricing_rules1);
};
$error = $@ if $@;

like($error, qr/Item C not found in pricing data/, 'Test3: Item not found should throw error');

done_testing();