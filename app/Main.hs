{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (unless)
import Data.Word
import SDL
import SDL.Raw.Enum

main :: IO ()
main = do
  initializeAll
  window <-
    createWindow
      "My SDL Application"
      defaultWindow {windowInitialSize = V2 100 100, windowBorder = False}
  windowOpacity window $= 0.3
  renderer <- createRenderer window (-1) defaultRenderer
  appLoop renderer window 0
  destroyWindow window

appLoop :: Renderer -> Window -> Word8 -> IO ()
appLoop renderer window state = do
  events <- pollEvents
  let eventIsQPress event =
        case eventPayload event of
          KeyboardEvent keyboardEvent ->
            keyboardEventKeyMotion keyboardEvent == Pressed
              && keysymKeycode (keyboardEventKeysym keyboardEvent) == KeycodeQ
          _ -> False
      qPressed = any eventIsQPress events
  -- rendererDrawBlendMode renderer $= SDL_BLENDMODE_ADD
  rendererDrawColor renderer $= V4 (mod state 255) 0 80 10
  clear renderer
  present renderer
  get (windowOpacity window) >>= print
  delay 10
  unless qPressed (appLoop renderer window (state + 1))
