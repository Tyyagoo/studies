{-# LANGUAGE RecordWildCards #-}

module Robot
    ( Bearing(East,North,South,West)
    , bearing
    , coordinates
    , mkRobot
    , move
    ) where

data Bearing = North
             | East
             | South
             | West
             deriving (Eq, Show)

data Robot = Robot { direction :: Bearing, position :: (Integer, Integer) }

bearing :: Robot -> Bearing
bearing Robot { .. } = direction

coordinates :: Robot -> (Integer, Integer)
coordinates Robot { .. } = position

mkRobot :: Bearing -> (Integer, Integer) -> Robot
mkRobot dir pos = Robot { direction = dir, position = pos }

move :: Robot -> String -> Robot
move robot@Robot{ .. } inst = foldl (move') robot inst

move' robot@Robot{ .. } 'R' = robot { direction = turnRight direction }
move' robot@Robot{ .. } 'L' = robot { direction = turnLeft direction }
move' robot@Robot{ .. } 'A' = robot { position = advance direction position}

turnRight North = East
turnRight East = South
turnRight South = West
turnRight West = North

turnLeft North = West
turnLeft West = South
turnLeft South = East
turnLeft East = North

advance North (x, y) = (x, y + 1)
advance South (x, y) = (x, y - 1)
advance East (x, y) = (x + 1, y)
advance West (x, y) = (x - 1, y)