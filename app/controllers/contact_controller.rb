class ContactController < ApplicationController
    def new

    end
    
    def create
        # We define an instance variable here in order to be able to access the variable in the view file.
        @name = params["name"]
    end
end
