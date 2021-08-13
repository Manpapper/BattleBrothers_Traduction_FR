this.defeat_holywar_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_holywar";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les feux de la tourmente religieuse menacent d\'engloutir les terres. Laissez la compagnie être forgée plus forte que jamais par la chaleur et les flammes, et gagnez une fortune en gagnant la guerre !";
		this.m.UIText = "Mettre fin à la guerre entre le nord et le sud";
		this.m.TooltipText = "Choisissez les maisons nobles du nord ou les villes-états du sud et travaillez avec elles pour gagner leur guerre sainte. Chaque armée détruite, et chaque contrat rempli, vous rapprochera de la fin de la guerre.";
		this.m.SuccessButtonText = "Qu\'ils nous aiment ou nous détestent, tout le monde connaît %companyname% maintenant !";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.95)
		{
			text = "Viens de commencer";
		}
		else if (f >= 0.5)
		{
			text = "En cours";
		}
		else if (f >= 0.25)
		{
			text = "Traîne en longueur";
		}
		else
		{
			text = "Pratiquement fini";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function getSuccessText()
	{
		local north = 0;
		local south = 0;
		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0)
				{
					if (this.World.FactionManager.getFaction(v.getFaction()).getType() == this.Const.FactionType.NobleHouse)
					{
						north = ++north;
					}
					else
					{
						south = ++south;
					}
				}
			}
		}

		if (north >= south)
		{
			return "[img]gfx/ui/events/event_92.png[/img]{L\'air que vous respirez, le sol sous vos pieds, rien ne semble différent. Pourtant, autour de vous, les foules du Nord se réjouissent, comme si chaque âme avait été comblée de tous ses vœux. Vous avez appris que les Sudistes ont cédé et envoyé les colombes, mettant fin à la guerre sainte en faveur du Nord. En retour, le Nord aura l\'occupation des lieux saints et autorisera l\'entrée au Sud, à condition qu\'ils soumettent que leur \"Gilder\" n\'est qu\'un des nombreux dieux du panthéon des anciens dieux. Une jeune fille vient vous voir avec une fleur.%SPEECH_ON%Ils parlent de chevaliers et de héros, mais je vous ai vu moi-même. Vous êtes allé par là, et de bonnes nouvelles sont arrivées, et vous êtes allé par là, et d\'autres bonnes nouvelles sont arrivées. C\'était comme si vous étiez envoyé par le ciel, la main droite des vieux dieux eux-mêmes.%SPEECH_OFF%Vous remerciez la fille et elle pirouette et s\'enfuit. %randombrother% s\'approche de vous les lèvres pincées.%SPEECH_ON%Envoyé par le ciel et le mieux qu\'ils puissent faire c\'est de te donner une foutue fleur?%SPEECH_OFF%.}";
		}
		else
		{
			return "[img]gfx/ui/events/event_171.png[/img]{Vous regardez les foules de fidèles du grand Gilder se diriger vers les lieux saints, la terre entière libérée des chaînes de la guerre de religion, et la guerre sainte réglée en faveur du Sud. D\'après ce que vous avez entendu, les Vizirs ont appliqué une règle selon laquelle les habitants du Nord peuvent visiter les terres saintes, mais doivent payer une taxe aux gouverneurs qui supervisent ces territoires. C\'est un résultat avare, mais pas particulièrement violent et vengeur.\n\n Alors que vous faites le point sur votre inventaire, une douzaine de vieillards remontent la route et s\'arrêtent devant vous. Ils s\'annoncent comme des scribes et des historiens qui entreprennent le grand recueil de la guerre sainte. Apparemment, quelqu\'un leur a indiqué votre nom, mais ils ne savent pas vraiment qui vous êtes. Vous expliquez que les Vizirs vous ont engagé pour-%SPEECH_ON%Engagé, vous dites ?%SPEECH_OFF% Un des vieux hommes vous coupe la parole, sa plume d\'oie s\'arrêtant brusquement. Il secoue la tête.%SPEECH_ON%Non non non, nous cherchons à cataloguer les succès de ceux qui ont rendu les terres sacrées à la lumière de Gilder. Vous êtes un ranpant flétri, opportuniste et sans doute complice. Passez une bonne journée.%SPEECH_OFF%Ils partent avant que vous ne puissiez répliquer, bien que vous soupçonniez que si vous étiez d\'humeur à vous battre, vous leur auriez probablement donné un peu d\'acier. %randombrother% s\'approche et demande qui ils sont. Vous haussez les épaules. %SPEECH_ON% Juste une bande de bons à rien. %SPEECH_OFF%.}";
		}
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 4)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
		return false;
	}

	function onPrepareVariables( _vars )
	{
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

