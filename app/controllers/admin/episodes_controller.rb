class Admin::EpisodesController < Admin::BaseController
  before_filter :find_episode, except: [:index, :new, :create]
  def index
    @episodes = Episode.recent.all
  end

  def new
    @episode = Episode.new
    last_episode = Episode.recent.last
    @episode.position = last_episode ? last_episode.position + 1 : 1
  end

  def create
    @episode = Episode.new(params[:episode])
    if @episode.save
      @episode.update_file_sizes(params[:episode_file])
      redirect_to [:admin, @episode] and return
    end

    render :new
  end

  def update
    if @episode.update_attributes(params[:episode])
      @episode.update_file_sizes(params[:episode_file])
      redirect_to [:admin, @episode]
    else
      render :edit
    end
  end

  def destroy
    @episode.destroy
    redirect_to admin_episodes_url
  end

private

  def find_episode
    @episode = Episode.find_by_position(params[:id])
  end
end
