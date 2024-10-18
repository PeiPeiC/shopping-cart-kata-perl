use strict;
use warnings;
use Test::More; 
use lib './lib';
use ShoppingCart;
use File::Temp 'tempfile';

# Test 1: Success case for load_pricing_data
{
    # Create a temporary file with valid pricing data
    my ($fh, $filename) = tempfile();
    print $fh <<'JSON';
[
    {"item_code": "A", "unit_price": 50},
    {"item_code": "B", "unit_price": 30, "special_price": "3 for 75"}
]
JSON
    close $fh;

    # Load pricing data from the file and test the result
    my $pricing_data = ShoppingCart::load_pricing_data($filename);
    is_deeply($pricing_data, [
        { item_code => "A", unit_price => 50 },
        { item_code => "B", unit_price => 30, special_price => { quantity => 3, price => 75 } }
    ], 'Test1: Successfully load and parse pricing data');
}

# Test 2: Failure case for load_pricing_data (missing item_code)
{
    # Create a temporary file with invalid pricing data
    my ($fh, $filename) = tempfile();
    print $fh <<'JSON';
[
    {"unit_price": 50}
]
JSON
    close $fh;

    # Use eval to capture errors manually
    my $error;
    eval {
        ShoppingCart::load_pricing_data($filename);
    };
    $error = $@ if $@;

    # Now check if the error matches the expected pattern
    like($error, qr/Invalid pricing data: missing item code/, 'Test2: Missing item_code should throw error');
}

done_testing();  # Ensure parentheses are used
