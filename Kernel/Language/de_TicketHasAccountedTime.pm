# --
# Copyright (C) 2018 Perl-Services.de, http://perl-services.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_TicketHasAccountedTime;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation} || {};

    $Lang->{'Accounted Time'}  = 'Erfasste Zeiten';

    return 1;
}

1;
