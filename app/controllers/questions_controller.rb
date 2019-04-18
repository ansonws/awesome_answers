class QuestionsController < ApplicationController
    # Order matters for before_action
    before_action :authenticate_user!, except: [:index, :show]
    before_action :find_question, only: [:show, :edit, :update, :destroy]
    before_action :authorize, only: [:edit, :update, :destroy]

    def new
        @question = Question.new
    end

    def create
        @question = Question.new question_params
        @question.user = current_user
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
        @like = @question.likes.find_by(user: current_user)
    end

    def index
        @questions = Question.all.order(created_at: :DESC)
    end
    
    def edit
        # if @question.user != current_user
        unless can? :edit, @question
            redirect_to root_path, alert: 'Not authorized'
        end
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

    def authorize
        redirect_to root_path, alert: 'Not Authorized' unless can? :crud, @question
    end

end
