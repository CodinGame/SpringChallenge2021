Module Player
    Public Sub Main()
        Dim inputs As String()

        Dim Game As New Game

        Dim numberOfCells As Integer = CInt(Console.ReadLine()) ' 37
        For i As Integer = 0 To numberOfCells - 1
            inputs = Console.ReadLine().Split(" "c)
            Dim index = CInt(inputs(0)) ' 0 is the center cell, the next cells spiral outwards
            Dim richness = CInt(inputs(1)) ' 0 if the cell is unusable, 1-3 for usable cells
            Dim neigh0 = CInt(inputs(2)) ' the index of the neighbouring cell for each direction
            Dim neigh1 = CInt(inputs(2))
            Dim neigh2 = CInt(inputs(2))
            Dim neigh3 = CInt(inputs(2))
            Dim neigh4 = CInt(inputs(2))
            Dim neigh5 = CInt(inputs(2))
        Next

        ' game loop
        While True
            Game.day = CInt(Console.ReadLine()) ' the game lasts 24 days: 0-23
            Game.nutrients = CInt(Console.ReadLine()) ' the base score you gain from the next COMPLETE Command
            inputs = Console.ReadLine().Split(" "c)
            Game.mySun = CInt(inputs(0)) ' your sun points
            Game.myScore = CInt(inputs(1)) ' your current score
            inputs = Console.ReadLine().Split(" "c)
            Game.opponentSun = CInt(inputs(0)) ' opponent's sun points
            Game.opponentScore = CInt(inputs(1)) ' opponent's score
            Game.opponentIsWaiting = inputs(2) <> "0" ' whether your opponent is asleep until the next day

            Game.trees.Clear()
            Dim numberOfTrees As Integer = CInt(Console.ReadLine()) ' the current amount of trees
            For i As Integer = 0 To numberOfTrees - 1
                inputs = Console.ReadLine().Split(" "c)
                Dim cellIndex As Integer = CInt(inputs(0)) ' location of this tree
                Dim size As Integer = CInt(inputs(1)) ' size of this tree: 0-3
                Dim isMine As Boolean = inputs(2) <> "0" ' 1 if this is your tree
                Dim isDormant As Boolean = inputs(3) <> "0" ' 1 if this tree is dormant
                Dim tree1 As New Tree(cellIndex, size, isMine, isDormant)
                Game.trees.Add(tree1)
            Next

            Game.possibleCommands.Clear()
            Dim numberOfPossibleMoves As Integer = CInt(Console.ReadLine())
            For i As Integer = 0 To numberOfPossibleMoves - 1
                Dim possibleMove As String = Console.ReadLine()
                Game.possibleCommands.Add(Command.Parse(possibleMove))
            Next

            Dim C As Command = Game.GetNextCommand()
            Console.WriteLine(C)

        End While
    End Sub
End Module

Class Game
    Public day As Integer
    Public nutrients As Integer
    Public board As List(Of Cell)
    Public possibleCommands As List(Of Command)
    Public trees As List(Of Tree)
    Public mySun, opponentSun As Integer
    Public myScore, opponentScore As Integer
    Public opponentIsWaiting As Boolean

    Public Sub New()
        board = New List(Of Cell)
        possibleCommands = New List(Of Command)
        trees = New List(Of Tree)
    End Sub

    Public Function GetNextCommand() As Command
        ' TODO: write your algorithm here
        Return possibleCommands.First()
    End Function
End Class

Class Cell
    Public index As Integer
    Public richess As Integer
    Public neighbours() As Integer

    Public Sub New(index As Integer, richess As Integer, neighbours() As Integer)
        Me.index = index
        Me.richess = richess
        Me.neighbours = neighbours
    End Sub
End Class

Class Tree
    Public cellIndex As Integer
    Public size As Integer
    Public isMine As Boolean
    Public isDormant As Boolean

    Public Sub New(cellIndex As Integer, size As Integer, isMine As Boolean, isDormant As Boolean)
        Me.cellIndex = cellIndex
        Me.size = size
        Me.isMine = isMine
        Me.isDormant = isDormant
    End Sub
End Class

Class Command
    Public Const WAIT As String = "WAIT"
    Public Const SEED As String = "SEED"
    Public Const GROW As String = "GROW"
    Public Const COMPLETE As String = "COMPLETE"

    Public Shared Function Parse(Command As String) As Command
        Dim parts As String() = Command.Split(" "c)
        Select Case parts(0)
            Case WAIT
                Return New Command(WAIT)
            Case SEED
                Return New Command(SEED, CInt(parts(1)), CInt(parts(2)))
            Case Else
                Return New Command(parts(0), CInt(parts(1)))
        End Select
    End Function

    Public type As String
    Public targetCellIdx As Integer
    Public sourceCellIdx As Integer

    Public Sub New(type As String)
        Me.New(type, 0, 0)
    End Sub

    Public Sub New(type As String, targetCellIdx As Integer)
        Me.New(type, 0, targetCellIdx)
    End Sub

    Public Sub New(type As String, sourceCellIdx As Integer, targetCellIdx As Integer)
        Me.type = type
        Me.targetCellIdx = targetCellIdx
        Me.sourceCellIdx = sourceCellIdx
    End Sub

    Public Overrides Function ToString() As String
        If type = WAIT Then
            Return Command.WAIT
        End If
        If type = SEED Then
            Return $"{SEED} {sourceCellIdx} {targetCellIdx}"
        End If

        Return $"{type} {targetCellIdx}"
    End Function
End Class
