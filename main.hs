{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
import Prelude
import System.Environment
import Yesod

--
-- Types
--
data Jacquard = Jacquard

data AppVersion = AppVersion { name :: String,
                               major :: Int,
                               minor :: Int,
                               micro :: Int }


            
--
-- Type classes
--
instance Show AppVersion where
  show (AppVersion name major minor micro) =
    concat [name, "-", show major, ".", show minor, ".", show micro]

--
-- Helper functions
--
appVersion :: AppVersion
appVersion = AppVersion "jacquard" 0 0 1

versionStr :: String
versionStr = show appVersion

versionToJsonObject :: AppVersion -> Value
versionToJsonObject (AppVersion name major minor micro) =
  object ["name" .= name,
          "major" .= major,
          "minor" .= minor,
          "micro" .= micro]

--
-- Routing
--
mkYesod "Jacquard" [parseRoutes|
                    /version VersionR GET 
                               |]

instance Yesod Jacquard

--
-- Handlers
--
getVersionR :: Monad m => m Value
getVersionR = return $ object ["version" .= versionToJsonObject appVersion]

--
-- Run
--
main :: IO ()
main = do
  args <- getArgs 
  let port = (if length args > 0
              then read (args !! 0) :: Int
              else 3000)
    in warp port Jacquard
