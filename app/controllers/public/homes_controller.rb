class Public::HomesController < ApplicationController
    before_action :authenticate_user!, :only => [:about]

    def about
    end
end
