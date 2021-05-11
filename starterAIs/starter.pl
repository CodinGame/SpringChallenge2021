use strict;
use warnings;
use 5.32.1;
select STDOUT; $|=1;
my $game = new Game();
loadMap();
while (1) {
    loadTurn();
    say $game->getNextAction();
}

######################## subs

sub loadMap {
    chomp(my $number_of_cells = <STDIN>); # 37
    
    for my $i (0..$number_of_cells-1) {
        chomp(my $tokens=<STDIN>);
        my @parms = split / /,$tokens;
        my $cell = new Cell(shift @parms, shift @parms, \@parms);
        push @{ $game->{cells} }, $cell;
    }
}

sub loadTurn {
    chomp($game->{day} = <STDIN>);
    chomp($game->{nutrients} = <STDIN>);

    chomp(my $t = <STDIN>);
    ($game->{mySun}, $game->{myScore}) = split / /, $t;

    chomp($t = <STDIN>);
    ($game->{oppSun}, $game->{oppScore}, $game->{oppIsWaiting}) = split / /, $t;

    chomp(my $number_of_trees = <>);
    my @trees;
    for my $i (0..$number_of_trees-1) {
        my $tree = new Tree();
        chomp($t = <>);
        ($tree->{cellIndex}, $tree->{size}, $tree->{isMine}, $tree->{isDormant}) = split / /, $t;
        push @trees, $tree;
    }
    $game->{trees} = \@trees;
    
    chomp(my $number_of_actions = <>);
    my @actions;
    for my $i (0..$number_of_actions-1) {
        chomp($t = <>);
        my $action = Action->parse($t);
        push @actions, $action;
        #say STDERR $action->getAction();
    }
    $game->{possActions} = \@actions;
}

######################## classes

package Game;

sub new {
    my $type = shift;
    my (@cellArray, @actionArray, @treeArray);
    my $self = {
        day => 0,
        nutrients => 0,
        cells => \@cellArray,
        possActions => \@actionArray,
        trees => \@treeArray,
        mySun => 0,
        myScore => 0,
        oppSun => 0,
        oppScore => 0,
        oppIsWaiting => 0
    };
    return bless $self, $type;
}

sub getNextAction {
    my $self = shift;

    #Your logic to determine the next action goes here.

    return $self->{possActions}[0]->getAction();
}

package Cell;

sub new {
    my $type = shift;
    my $self = {
        index => shift,              
        richness => shift,
        neighbors => shift
    };
    return bless $self, $type;
}

package Tree;

sub new {
    my $type = shift;
    my $self = {
        cellIndex => shift,
        size => shift,
        isMine => shift,
        isDormant => shift
    };
    return bless $self, $type;
}

package Action;

use constant COMPLETE => "COMPLETE";
use constant GROW => "GROW";
use constant SEED => "SEED";
use constant WAIT => "WAIT";

sub new {
    my $type = shift;
    my $self = {
        type => shift,
        target => shift,
        source => shift
    };
    return bless $self, $type;
}

sub parse {
    my ($self, $line) = @_;
    my @parts = split / /, $line;

    if ($parts[0] eq WAIT) {
        return new Action(WAIT);
    }

    if ($parts[0] eq SEED) {
        return new Action(SEED, $parts[2], $parts[1]);
    }

    return new Action($parts[0], $parts[1]);
}

sub getAction {
    my ($self) = @_;

    if ($self->{type} eq WAIT) {
        return WAIT;
    }

    if ($self->{type} eq SEED) {
        return SEED." ".$self->{target}." ".$self->{source};
    }

    return $self->{type}." ".$self->{target};   
}


