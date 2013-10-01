defmodule Kuraudo do
  @moduledoc """
  Kuraudo (クラウド) is a multi-cloud framework for [Elixir](http://elixir-lang.org). It support CIMI, OCCI, EC2/S3, OpenStack

  ### Synopsis

      # start Kuraudo
      Kuraudo.start

      # create a driver for Amazon
      driver = Kuraudo.AWS.Driver[
          access_key_id: 'accesskey', 
          secret_access_key: 'secretkey'
      ] 
      
      # Initialize the connection to the provider
      driver = Kuraudo.Provider.connect(driver)

      # Get the liste of availables images
      images_list = Kuraudo.Provider.images(driver, ["Owner.0": "amazon"])

  ### Licence

  I don't know yet :/
  """
  @doc """
  Start Kuraudo
  """
  def start do
    HTTPotion.start
    Logger.start
    :application.start(:mimetypes)
  end

  @doc """
  Return the Kuraudo version
  """
  def version, do: "0.0.1-alpha"

  @doc false
  def default_http_timeout, do: 60000
end
