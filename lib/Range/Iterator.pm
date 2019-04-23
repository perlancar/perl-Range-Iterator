package Range::Iterator;

# DATE
# VERSION

use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

sub new {
    my $class = shift;
    my ($start, $end, $step) = @_;
    $step //= 1;

    my $self = {
        start => $start,
        end   => $end,
        step  => $step,

        _ended => 0,
        _cur   => $start,
    };

    if (looks_like_number($start) && looks_like_number($end)) {
        $self->{_num}   = 1;
        $self->{_ended}++ if $start > $end;
    } else {
        die "Cannot specify step != 1 for non-numeric range" if $step != 1;
        $self->{_ended}++ if $start gt $end;
    }
    bless $self, $class;
}

sub next {
    my $self = shift;

    if ($self->{_num}) {
        $self->{_ended}++ if $self->{_cur} > $self->{end};
        return undef if $self->{_ended};
        my $old = $self->{_cur};
        $self->{_cur} += $self->{step};
        return $old;
    } else {
        return undef if $self->{_ended};
        $self->{_ended}++ if $self->{_cur} ge $self->{end};
        $self->{_cur}++;
    }
}

1;
#ABSTRACT: Generate an iterator object for range

=for Pod::Coverage .+

=head1 SYNOPSIS

  use Range::Iterator;

  my $iter = Range::Iterator->new(1, 10);
  while (defined(my $val = $iter->next)) { ... } # 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

You can add step:

 my $iter = Range::Iterator->new(1, 10, 2); # 1, 3, 5, 7, 9

You can use alphanumeric strings too since C<++> has some extra builtin magic
(see L<perlop>):

 $iter = Range::Iterator->new("zx", "aab"); # zx, zy, zz, aaa, aab

Infinite list:

 $iter = Range::Iterator->new(1, Inf); # 1, 2, 3, ...


=head1 DESCRIPTION

This module offers an object-based iterator for range.


=head1 METHODS

=head2 new

Usage:

 $obj = Range::Iterator->new($start, $end [ , $step ])

=head2 next

Usage:

 my $val = $obj->next

Return the next value, or undef if there is no more values.


=head1 SEE ALSO

L<Range::Iter>

L<Range::ArrayIter>

L<Array::Iterator> & L<Array::Iter> offer iterators for list/array.

=cut
