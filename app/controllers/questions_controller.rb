class QuestionsController < ApplicationController
    # Order matters for before_action
    before_action :find_question, only: [:show, :edit, :update]
    before_action :authenticate_user 

    def new
        @question = Question.new
    end

    def create
        @question = Question.new question_params
        if @question.save
            # The redirect_to method is used for telling the browser to make a new request.
            # The redirect_to method is typically used with a named route helper.
            redirect_to question_path(@question.id) # Omitting .id also works in rails
        else
            render :new 
        end
    end
        
    def show
    end

    def index
        @questions = Question.all.order(created_at: :desc)
    end
    
    def edit
    end
    
    def update
        question_params =  params.require(:question).permit(:title, :body)
        if @question.update question_params
            redirect_to question_path(@question)
        else
            render :edit
        end
    end

    def destroy
        question = Question.find(params[:id])
        question.destroy
        redirect_to root_path
    end

    private

    def create
        # The 'params' object available in controllers is composed of the query string, url params, and the body of a form
        # e.g. req.query + req.params + req.body
        # A good trick to see if your routes are working and you're getting the data that you want, is to render the params as JSON. 
        # e.g. render json: params
        # This is like doing res.send(req.body) in Express
        
        # Use 'require' on the params object to retrieve the nested hash of a key usually corresponding to the name-value pairs of a form.
        # Then use permit to specify all input names that are allowable as symbols.
        question_params =  params.require(:question).permit(:title, :body)
    end

    def question_params
        # Use 'require' on the params object to retrieve the nested hash of a key usually corresponding to the name-value pairs of a form
    
        # Then use permit to specify all input names that are allowable (as symbols).
        params.require(:question).permit(:title, :body)
    end
end
