{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# LANGUAGE OverloadedStrings     #-}


{-# LANGUAGE DuplicateRecordFields #-}

module Main where

import           Control.Monad

import           Control.Monad.Trans.Except
import           Data.Aeson                 ((.:))
import qualified Data.Aeson                 as Aeson
import qualified Data.Bifunctor             as Bi
import           Data.Text                  as Text
import qualified Options.Applicative        as Opt
import           Protolude                  hiding (FilePath)
import           System.Environment         (lookupEnv)
import           Turtle

-- Env

data Env = Env
  { envConfigFile :: Text
  , envHome       :: Text
  }

getEnv :: IoErr Env
getEnv =
  Env
    <$> lookupEnv' "CONFIG_FILE"
    <*> lookupEnv' "HOME"

-- Config

data Config = Config
  { cfgPkgs      :: [Text]
  , cfgLnDir     :: Text
  , cfgBookmarks :: [Bookmark]
  }
  deriving (Show, Generic)

instance Aeson.FromJSON Config where
  parseJSON (Aeson.Object obj) =
    Config
      <$> obj .: "pkgs"
      <*> obj .: "lnDir"
      <*> obj .: "bookmarks"
  parseJSON _ = mzero

data Bookmark = Bookmark
  { bmName   :: Text
  , bmTarget :: Text
  }
  deriving (Show, Generic)

instance Aeson.FromJSON Bookmark where
  parseJSON (Aeson.Object obj) =
    Bookmark
      <$> obj .: "name"
      <*> obj .: "target"
  parseJSON _ = mzero

-- Args

data Args = CmdCreateLinks

parseArgs :: Opt.Parser Args
parseArgs =
  Opt.subparser
    ( Opt.command "create-links" (Opt.info (pure CmdCreateLinks) mempty)
    )

parseInfo :: Opt.ParserInfo Args
parseInfo =
  Opt.info (parseArgs <**> Opt.helper) Opt.fullDesc

-- IO Err

data Err
  = ErrMissingEnvVar Text
  | ErrReadJson Text
  deriving (Show)

type IoErr a = ExceptT Err IO a

lookupEnv' :: Text -> IoErr Text
lookupEnv' name =
  fmap Text.pack
  $ ExceptT
  $ fmap (note error)
  $ lookupEnv name'
  where
    error = ErrMissingEnvVar name
    name' = Text.unpack name

readJsonFile :: Aeson.FromJSON a => Text -> IoErr a
readJsonFile path =
  ExceptT
  $ fmap (Bi.first mkError)
  $ Aeson.eitherDecodeFileStrict path'
  where
    path' = Text.unpack path
    mkError = ErrReadJson . Text.pack

-- Main

getEnvAndConfig :: IoErr (Env, Config)
getEnvAndConfig = do
  env <- getEnv
  config <-
    readJsonFile (envConfigFile env)
  pure (env, config)

runIoErr :: IoErr a -> IO a
runIoErr x = do
  result <- runExceptT x
  case result of
    Left err -> do
      print $ Text.unpack $ show err
      exitFailure
    Right ok ->
      pure ok

cmdCreateLinks :: (Env, Config) -> IO ()
cmdCreateLinks (env, cfg) = do
  isExists <-
    fmap isDirectory (lstat dir)
  if isExists
    then rmtree dir
    else pure ()
  mkdir dir
  traverse_ (mkLink dir) (cfgBookmarks cfg)
  where
     dir =
       fromText (envHome env) </> fromText (cfgLnDir cfg)

mkLink :: FilePath -> Bookmark -> IO ()
mkLink dir bookmark =
  symlink target name
  where
    target =
      fromText $ bmTarget bookmark
    name =
      dir </> (fromText $ bmName bookmark)

runCmd :: (Env, Config, Args) -> IO ()
runCmd (env, config, args) =
  case args of
    CmdCreateLinks -> cmdCreateLinks (env, config)

main :: IO ()
main = do
  (env, config) <- runIoErr getEnvAndConfig
  args <- Opt.execParser parseInfo
  runCmd (env, config, args)
