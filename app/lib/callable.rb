module Callable
  def call(*args)
    new(*args).perform
  end
end
