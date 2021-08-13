this.win_x_arena_fights_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ArenaMatchesToWin = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_x_arena_fights";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Cherchons la gloire et la fortune en nous battant devant des foules qui scandent nos noms. Nous ferons couler le sang dans les arènes du sud !";
		this.m.UIText = "Gagner des combats d\'arène";
		this.m.TooltipText = "Participez et gagnez 5 combats dans l\'arène des Cités-Etats du Sud.";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]Après avoir éliminé toutes sortes de créatures qui marchent sur deux jambes ou plus, et parfois même aucune, vous avez acquis une certaine renommée pour vos prouesses de gladiateur. Les habitants du Sud prononcent votre nom comme s\'il était porteur de bonnes nouvelles, se délectant par procuration de vos victoires et espérant vous voir en remporter d\'autres. C\'est un étrange tour du destin, car la plupart des gens se rendent aux arènes pour voir les gladiateurs mourir de la façon la plus horrible possible. Le fait que les masses vous acclament est en effet une réalisation étrange, bien que vous réalisiez que lorsque c\'est vous dans cette lumière, votre présence même remplissant les tribunes et les rampes, il y a toujours une fin hideuse que la foule recherche : celle de votre adversaire. Et, franchement, pour autant d\'argent, vous n\'avez aucun problème à satisfaire la soif de sang du public.";
		this.m.SuccessButtonText = "Je les entends encore scander nos noms !";
	}

	function getUIText()
	{
		local d = 5 - (this.m.ArenaMatchesToWin - this.World.Statistics.getFlags().getAsInt("ArenaFightsWon"));
		return this.m.UIText + " (" + this.Math.min(5, d) + "/5)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") > 10)
		{
			return;
		}

		this.m.ArenaMatchesToWin = this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") + 5;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= this.m.ArenaMatchesToWin)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ArenaMatchesToWin);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 55)
		{
			this.m.ArenaMatchesToWin = _in.readU16();
		}
	}

});

