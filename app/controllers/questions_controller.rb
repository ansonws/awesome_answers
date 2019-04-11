class QuestionsController < ApplicationController
    # Order matters for before_action
    before_action :find_question, only: [:show, :edit, :update, :destroy]

    def new
        @question = Question.new
    end

    def create
        @question = Question.new question_params
        if @question.save
            # The redirect_to method is used for telling the browser to make a new request.
            # The redirect_to method is typically used with a named route helper.
            redirect_to question_path(@question) # Omitting .id also works in rails
        else
            render :new 
        end
    end
        
    def show
        # For the form_with helper
        @answer = Answer.new
        # For the list of answers
        @answers = @question.answers.order(created_at: :DESC)
    end

    def index
        @questions = Question.all.order(created_at: :DESC)
    end
    
    def edit
    end
    
    def update
        if @question.update question_params
            redirect_to question_path(@question)
        else
            render :edit
        end
    end

    def destroy
        @question.destroy
        redirect_to root_path
    end

    private

    def question_params
        # Use 'require' on the params object to retrieve the nested hash of a key usually corresponding to the name-value pairs of a form
    
        # Then use permit to specify all input names that are allowable (as symbols).
        params.require(:question).permit(:title, :body)
    end

    def find_question
        @question = Question.find(params[:id])
    end

end
