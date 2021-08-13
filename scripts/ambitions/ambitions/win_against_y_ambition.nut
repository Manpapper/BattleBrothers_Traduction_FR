this.win_against_y_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_y";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous avons atteint une certaine renommée, mais maintenant vous pouvez voir la vrai gloire à l\'horizon. Laissez-nous vaincre une force formidable de deux douzaines d\'adversaires dans la bataille !";
		this.m.UIText = "Gagner une bataille contre 24 ennemis ou plus";
		this.m.TooltipText = "Gagnez une bataille contre 24 ennemis ou plus, que ce soit en les tuant ou en les faisant se disperser et fuir. Vous pouvez le faire dans le cadre d\'un contrat ou en vous battant à votre guise.";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]Après le combat, %lowesthp_brother% est assis et regarde ses pieds, l\'air complètement crevé, tout comme les autres. C\'était la bataille pour laquelle j\'étais né ! Maintenant si je meurs, ce sera aux côtés de la bande d\'hommes la plus courageuse et la plus mortelle que j\'ai jamais connue, et je suis fier de les appeler mes frères !%SPEECH_OFF%Ceci est accueilli par un chœur de consentements las tout autour.%SPEECH_ON%Les paysans parlent de sueur, de sang et de larmes mais les hommes de %companyname% ont marché dans le feu et l\'ont emporté !%SPEECH_OFF%Trois fois, les hommes crient le nom de la compagnie, fatigués mais victorieux.\n\nDans les jours qui suivent, vous constatez que partout où les gens civilisés se rassemblent, ils vous désignent et chuchotent, que ce soit par peur ou par admiration, vous ne savez pas. Partout où vous allez, la rumeur de votre puissante victoire a parcouru le pays avant vous.";
		this.m.SuccessButtonText = "Qui osera se dresser contre nous maintenant ?";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.win_against_x").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24 || this.m.IsFulfilled)
		{
			return true;
		}

		return false;
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onPartyDestroyed( _party )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeBool(this.m.IsFulfilled);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.IsFulfilled = _in.readBool();
	}

});

