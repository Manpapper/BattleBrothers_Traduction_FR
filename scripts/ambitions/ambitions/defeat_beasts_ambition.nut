this.defeat_beasts_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		BeastsToDefeat = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_beasts";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les bêtes sauvages assaillent les villages en bordure de la civilisation. Nous allons les chasser pour faire du profit !";
		this.m.UIText = "Vaincre des meutes de bêtes errantes";
		this.m.TooltipText = "Battez 5 meutes de bêtes errantes au combat, comme les Loups-Garoux ou les Nachzehrers, que ce soit dans le cadre d\'un contrat ou en les recherchant vous-même.";
		this.m.SuccessText = "[img]gfx/ui/events/event_56.png[/imgAprès avoir éliminé une nouvelle bande de bêtes, vous vous interrogez sur la nature de vos ancêtres. Vous êtes là, organisés, armés et blindés, vous avez parcouru le monde, vous avez de l\'expérience en matière de guerre et de combat, et pourtant les monstres de ce monde sont toujours aussi dangereux. Vos ancêtres, qu\'avaient-ils ? Aucune civilisation pour se couvrir, aucune ville pour éclairer la nuit et réchauffer le courage, aucune carte pour donner une frontière réconfortante au monde. Et pourtant... ils ont survécu.\n\n Qu\'est-ce que c\'était ? Comment ? Peut-être qu\'à cette époque, c\'était l\'homme qui était la menace, et les bêtes le considéraient comme un monstre. Ou peut-être y a-t-il des temps avant les anciens, des temps où ils avaient leurs propres villes, et où le monde entier se déplace simplement en équilibre, bête et homme, depuis des temps immémoriaux. Et si c\'est le cas, alors ce n\'est pas sur le passé qu\'il faut s\'attarder, mais sur les jours, les années et les millénaires à venir...";
		this.m.SuccessButtonText = "Les hommes et les bêtes connaîtront notre nom.";
	}

	function getUIText()
	{
		local d = 5 - (this.m.BeastsToDefeat - this.World.Statistics.getFlags().getAsInt("BeastsDefeated"));
		return this.m.UIText + " (" + this.Math.min(5, d) + "/5)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.beast_hunters")
		{
			return;
		}

		this.m.BeastsToDefeat = this.World.Statistics.getFlags().getAsInt("BeastsDefeated") + 5;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("BeastsDefeated") >= this.m.BeastsToDefeat)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.BeastsToDefeat);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.BeastsToDefeat = _in.readU16();
	}

});

