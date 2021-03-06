class FacturesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :validation]
  before_action :set_facture, only: [:show, :edit, :update, :destroy]

  # GET /factures
  # GET /factures.json
  def index
    @factures = Facture.all

    unless params[:search].blank?
      s = "%#{params[:search].upcase}%"
      @factures = @factures
                    .joins(:cibles)
                    .where("cibles.email ILIKE ? OR factures.num_chrono::text ILIKE ? OR factures.société ILIKE ? OR factures.par ILIKE ?", s, s, s, s)
    end

    unless params[:workflow_state].blank?
      @factures = @factures.where("factures.workflow_state = ?", params[:workflow_state].to_s.downcase)
    end

    unless params[:filter].blank?
      if params[:filter] == 'in'
        @factures = @factures.where.not(workflow_state: 'imputée')
      else
        @factures = @factures.where(workflow_state: 'imputée')
      end
    end

    unless params[:typefacture].blank?
      @factures = @factures.where("factures.typefacture = ?", params[:typefacture])
    end

    respond_to do |format|
      format.html do
        @factures = @factures.distinct
        @total = @factures.sum(:montantHT)
        @factures = @factures.paginate(page: params[:page]).includes(:cibles)
        @sub_total = @factures.sum(:montantHT)
      end

      format.xls do
        book = Facture.to_xls(@factures)
        file_contents = StringIO.new
        book.write file_contents # => Now file_contents contains the rendered file output
        filename = "Factures.xls"
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end
    end

  end

  def grid
    @factures = Facture.all
  end

  # GET /factures/1
  # GET /factures/1.json
  def show
    #if @facture.scan.previewable?
      #@pdf_preview = @facture.scan.preview(resize: "827x1170>")
      #@pdf_preview = @facture.scan.preview(resize_to_limit: [100, 100])
    #end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Facture #{@facture.num_chrono}", 
               encoding: 'UTF-8'
      end
    end

  end

  # GET /factures/new
  def new
    @facture = Facture.new
    3.times { @facture.cibles.build }
  end

  # GET /factures/1/edit
  def edit
    3.times { @facture.cibles.build }
  end

  # POST /factures
  # POST /factures.json
  def create
    @facture = Facture.new(facture_params)

    respond_to do |format|
      if @facture.save

        # Envoyer la notification au premier destinataire
        if destinataire = @facture.cibles.first
          # Faire avancer le workflow_state juste qu'à l'état 'Envoyée' grâce à l'action 'Envoyer'
          @facture.envoyer!

          # Notifier le prochain destinataire 
          NotifierDestinataireJob.perform_later(destinataire)
        end

        format.html { redirect_to factures_url, notice: 'Facture créée avec succès. Le premier destinataire va être notifié par courriel dans quelques minutes.' }
        format.json { render :show, status: :created, location: @facture }
      else
        format.html { render :new }
        format.json { render json: @facture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /factures/1
  # PATCH/PUT /factures/1.json
  def update
    respond_to do |format|
      if @facture.update(facture_params)
        format.html { redirect_to @facture, notice: 'Facture modifiée avec succès.' }
        format.json { render :show, status: :ok, location: @facture }
      else
        format.html { render :edit }
        format.json { render json: @facture.errors, status: :unprocessable_entity }
      end
    end
  end

  def validation
    @facture = Facture.find_by(slug: params[:facture_id])
    # @pdf_preview = @facture.scan.preview(resize: "827x1170>")

    if action = params[:commit]
      # Marquer ce que la cible a répondu
      @facture.cibles.where(slug: params[:cible_slug]).each do |c|
        c.update!(repondu_le: DateTime.now, réponse: action, commentaires: params[:commentaires])
      end

      # Si la facture est rejetée, c'est terminé
      if action == "Rejeter"
        @facture.rejeter!
      else
        # sinon on teste s'il y a d'autres destinataires à qui demander une approbation
        if @facture.cibles.where(repondu_le: nil).any?
          # Notifier le prochain destinataire 
          destinataire = @facture.cibles.where(repondu_le: nil).first
          NotifierDestinataireJob.perform_later(destinataire)
        else 
          # sinon c'est validé
          @facture.valider!
        end
      end
        
      redirect_to facture_url(@facture), notice: "Réponse enregistrée, merci. Vous pouvez maintenant fermer cette page."
    end
  end

  def action
    return unless params[:factures_id]

    factures_id = params[:factures_id]
    factures = Facture.where(id: factures_id.keys)

    case params[:action_name]
    when "Relancer"
      # Envoyer à nouveau (relance) vers toutes les cibles
      factures = Facture.relancer(factures)
    
    when "Passer à l'état 'imputée'"
      factures = factures
        .with_validée_state
        .each do |f| 
          f.imputer!
      end
    end
    flash[:notice] = "#{factures.count} facture.s modifiée.s"  

    redirect_to factures_url
  end

  # DELETE /factures/1
  # DELETE /factures/1.json
  def destroy
    @facture.destroy
    respond_to do |format|
      format.html { redirect_to factures_url, notice: 'Facture détruite avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facture
      @facture = Facture.find_by(slug: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facture_params
      params.require(:facture).permit(:num_chrono, :typefacture, :po, :société, :scan, :montantHT, :commentaires, :workflow_state,
                                    cibles_attributes: [:id, :email, :répondu_le, :réponse, :_destroy])
    end
end
