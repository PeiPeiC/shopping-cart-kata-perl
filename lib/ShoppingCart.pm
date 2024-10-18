package ShoppingCart;

use strict;
use warnings;
use JSON;
use Carp qw(croak);

# Function to load the scanned items from a JSON file
sub load_pricing_data {
    my $pricing_file = shift;
    open my $fh, '<', $pricing_file or die "Could not open $pricing_file: $!";
    print "Loading pricing data from: $pricing_file\n";

    local $/; # enable slurp mode
    my $json_text = <$fh>; # read the whole file into array
    print "File content: $json_text\n";
    close $fh;
    # decode the json into an array of hashes
    my $pricing_data = decode_json($json_text);

    # validate the pricing data

    foreach my $item (@$pricing_data){ #dereference the array reference
        croak "Invalid pricing data: missing item code" unless exists $item->{item_code};
        croak "Invalid pricing data: missing item price" unless exists $item->{unit_price};
        if ($item->{special_price}){
            my $parsed_special = parse_special_price($item->{special_price});
            if ($parsed_special){
                # replace the special price string with the parsed hash
                $item->{special_price} = $parsed_special;
            }else{
                croak " Invalid special price format: $item->{special_price}";
            }
        }
    }
    return $pricing_data;
}

# Function to check the formating of the data and parse the special price string into a hash

# {
#     "item_code": "A",
#     "unit_price": 50,
#     "special_price": {
#         quantity => 3,
#         price    => 140
#     }
# }


sub parse_special_price{
    my $special_price = shift;

    if ($special_price && $ special_price =~/^(\d+) for (\d+)$/){
        return {quantity => $1, price => $2};
    }
    return undef; 
}

sub load_scanning_items{
    my $pricing_data = shift;
    open my $fh, '<', $pricing_data or die "Could not open $pricing_data: $!";
    local $/; # enable slurp mode
    my $json_text = <$fh>; # read the whole file into arrayß
    close $fh;
    # decode the json into an array of hashes
    $pricing_data = decode_json($json_text);
    return $pricing_data;

}

# Function to calculate the total price based on scanned items and pricing rules
sub calculate_subtotal {
    my ($scanned_items, $pricing_rules)= @_;
    my $sub_total = 0;


    # calculate the quantity of the same item to apply the special price

    my %items_quantity;
    foreach my $item (@$scanned_items) {
        my $item_code = $item->{code};
        my $quantity = $item->{quantity};
        $items_quantity{$item_code} += $quantity;
    }
    # calculate the subtotal based on the pricing rules with total quantity
    foreach my $item_code(keys %items_quantity) {
        my $quantity = $items_quantity{$item_code};

        my ($item_pricing) = grep{$_ -> {item_code} eq $item_code } @$pricing_rules;
        croak "Item $item_code not found in pricing data" unless $item_pricing;
        
        if ($item_pricing->{special_price}){
            my $special_qty = $item_pricing->{special_price}{quantity};
            my $special_price = $item_pricing->{special_price}{price};
            my $special_deals = int($quantity / $special_qty);
            my $remaining = $quantity % $special_qty;

            $sub_total += $special_deals * $special_price + $remaining * $item_pricing->{unit_price};
        }else{
            $sub_total += $quantity * $item_pricing->{unit_price};
        }
    }
    return $sub_total;
}
1;