this.have_y_renown_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_y_renown";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous sommes déjà connus dans certaines régions du pays, mais nous sommes \nencore loin d'être une compagnie légendaire. Nous allons encore accroître notre renommée !";
		this.m.UIText = "Atteindre la renommée de \"Glorieux\"";
		this.m.TooltipText = "Devenez connu en étant \"Glorieux\" (2 750 points de renoms) dans tout le pays. Vous pouvez augmenter votre renom en remplissant des contrats et en gagnant des batailles.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]En marchant à travers les forêts et les plaines, le groupe a écrasé toute opposition à laquelle il a été confronté. Piétinant les ennemis, brisant les lignes de bataille et faisant voler les têtes, %companyname% découvre qu'elle est rarement seule. Les corbeaux survolent la compagnie pendant qu'ils marchent, ils chantent pendant que les hommes prennent leur repas, et le plus souvent, ils festoient bien après que leur travail quotidien soit terminé. Dans leur sillage, les hommes laissent de la terre brûlée et des rumeurs farfelues partout où leurs pieds ont foulé le sol, chaque histoire s'amplifiant au fil des récits jusqu'à ce que tout le monde, des laitières aux forgerons en passant par les bourgeois, semble parler de vos exploits. Les rumeurs sont une monnaie d'échange appréciée dans tous les coins du pays, et ni les larges rivières ni les hauts sommets ne ralentiront les récits de vos victoires, et par conséquent, les prix que vous pouvez maintenant exiger pour vos services.";
		this.m.SuccessButtonText = "Les gens connaissent %companyname% maintenant !";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() >= 2650)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 2750)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

