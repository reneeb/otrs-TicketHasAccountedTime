# --
# Copyright (C) 2018 Perl-Services.de, http://perl-services.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::SetTicketHasAccountedTimes;

use strict;
use warnings;

use List::Util qw(first);

our @ObjectDependencies = qw(
    Kernel::System::Log
    Kernel::System::Time
    Kernel::System::DynamicField
    Kernel::System::DynamicField::Backend
    Kernel::System::Cache
    Kernel::System::Web::Request
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

    for my $Needed (qw(Data Event Config UserID)) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    for my $NeededData (qw(TicketID ArticleID)) {
        if ( !$Param{Data}->{$NeededData} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $NeededData in Data!",
            );

            return;
        }
    }

    my $HasAccountedTimeField = $DynamicFieldObject->DynamicFieldGet( Name => 'TicketHasAccountedTimes' );
    $BackendObject->ValueSet(
        DynamicFieldConfig => $HasAccountedTimeField,
        ObjectID           => $Param{Data}->{TicketID},
        Value              => 1,
        UserID             => 1,
    );

    my $AccountedTimeField = $DynamicFieldObject->DynamicFieldGet( Name => 'TicketAccountedTimes' );
    my $Value              = $TicketObject->TicketAccountedTimeGet( TicketID => $Param{Data}->{TicketID});

    $BackendObject->ValueSet(
        DynamicFieldConfig => $AccountedTimeField,
        ObjectID           => $Param{Data}->{TicketID},
        Value              => $Value,
        UserID             => 1,
    );

    return 1;
}

1;
