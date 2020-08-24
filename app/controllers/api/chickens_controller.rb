# class Api::V1::ChickensController < ApplicationController
class Api::ChickensController < ApplicationController
  def index
    head :ok
  end
end

# module Api
#   module V1
#     class PostsController < ApplicationController

#       def index
#         head :ok
#       end

#     end
#   end
# end
