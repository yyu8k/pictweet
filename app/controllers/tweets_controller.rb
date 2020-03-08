class TweetsController < ApplicationController

  before_action :move_to_index, except: :index

  def index
    @tweets = Tweet.includes(:user).page(params[:page]).per(5).order("created_at DESC")
    # order("created_at DESC")の解説
    # allメソッドを利用した場合、通常であればレコードはid順に取得されますが、上記のようにorderメソッドの引数として("id DESC")とすれば、レコードは逆順に並び替えられます。
    # orderメソッドは引数として("テーブルのカラム名 並び替える順序")という形を取ります。並び替える順序には、ASC(昇順)とDESC(降順)の2種類があります。
    # kaminariによるページネーションの解説
    # orderメソッドで取得した、最新順で並んでいるTweetsテーブルのレコードのインスタンスに対して、pageメソッドとperメソッドを利用します。pageメソッドとperメソッドによってそのページで表示すべきインスタンスを割り出し、返り値としています。
  end

  def new
  end

  def create
    Tweet.create(image: tweet_params[:image], text: tweet_params[:text], user_id: current_user.id)
  end

  def destroy
    tweet = Tweet.find(params[:id])
    if tweet.user_id == current_user.id
      tweet.destroy
    end
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    tweet = Tweet.find(params[:id])
    if tweet.user_id == current_user.id
      tweet.update(tweet_params)
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
    @comments = @tweet.comments.includes(:user)
  end


  private
  def tweet_params
    params.permit(:image, :text)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

end
