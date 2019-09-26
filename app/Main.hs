{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad.IO.Class (liftIO)
import           Data.Foldable (for_)
import qualified Data.Text as Text (pack)
import           System.Environment (getEnv, getEnvironment)
import           Snap.Core
                    ( Snap
                    , ifTop
                    , modifyResponse
                    , setHeader
                    , writeText
                    )
import           Snap.Http.Server (httpServe, setPort)

main :: IO ()
main = do
    port <- read <$> getEnv "PORT"
    let config = setPort port mempty
    httpServe config site

site :: Snap ()
site = ifTop indexHandler

indexHandler :: Snap ()
indexHandler = do
    modifyResponse $ setHeader "Content-Type" "text/html"
    writeText "<p>Hello from Haskell! and Philippe !</p>"
    env <- liftIO getEnvironment
    writeText "<ul>"
    for_ env $ \(k, v) ->
        writeText $ Text.pack ("<li> yeah ! " ++ k ++ "=" ++ v ++ "</li>")
    writeText "</ul>"
