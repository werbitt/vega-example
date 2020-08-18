module Main where

import Prelude
import Data.Argonaut.Core (Json)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    runUI myComponent unit body

foreign import data View :: Type

foreign import chartSpec :: Json

foreign import render :: String -> Json -> Effect View

myComponent ::
  forall query input output m.
  MonadAff m =>
  H.Component HH.HTML query input output m
myComponent =
  Hooks.component \_ _ -> Hooks.do
    Hooks.useLifecycleEffect do
      void $ liftEffect $ render "#chart" chartSpec
      pure Nothing
    Hooks.pure do
      HH.div_
        [ HH.p_
            [ HH.text "Vega Example" ]
        , HH.div
            [ HP.id_ "chart" ]
            [ HH.text "" ]
        ]
