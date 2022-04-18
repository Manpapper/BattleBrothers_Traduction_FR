this.holywar_intro_north_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_intro_north";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{%SPEECH_START%D'accord, d'accord, rangez-vous, rangez-vous.%SPEECH_OFF%Vous arrivez à un paysan qui tient un discour avec, sans surprise, d'autres paysans.%SPEECH_ON%Je viens d'apprendre que ces enfoirés dorés du sud pensent que leur faiseur a quelque chose en réserve pour les vieux dieux.%SPEECH_OFF%Une voix dans la foule demande ce que ça peut être. L'orateur hausse les épaules. %SPEECH_ON%Dunno. Maintenant, je pense que nous sommes tous d'accord pour dire que les anciens dieux ont réglé leurs guerres il y a de nombreuses années, et qu'il n'y a pas besoin de violence. Mais le doreur, ce n'est pas un ancien dieu. C'est une hérésie. La foule applaudit. Vous commencez à vous demander si cet homme n'est pas un clerc déguisé en roturier. Il continue.%SPEECH_ON%Recueillez vos armes, vos armures, votre or, et le plus important, votre foi, nous allons mettre de l'ombre sur ce doreur ! Les vieux dieux le veulent!%SPEECH_OFF%La foule rugit cette fois, si assourdissante que vos oreilles crépitent. Cela fait du bien de voir une telle énergie. Une fois que les combats auront commencé, il y aura beaucoup d'affaires car les justes trouveront certainement la foi dans le %companyname%. | On dit que les anciens dieux ont mené leurs guerres à terme il y a de nombreuses années, qu'ils ont déchiré ce monde et nous ont laissés dans la dévastation, et qu'ils ont été impressionnés par notre capacité à persévérer contre une si grande lutte. L'homme continue.%SPEECH_ON%Mais nous sommes encore défiés, vous les fidèles ! Au sud errent des hérétiques, des adeptes du 'doreur', un faux dieu de l'opulence, de la prodigalité, et d'une basse prestidigitation qu'ils font passer pour de la justice.%SPEECH_OFF%La foule ne sait pas ce que ces mots signifient, mais elle lève ses fourches en l'air et rugit, faisant signe aux clercs de leur dire où aller. En souriant, les anciens se tournent les uns vers les autres et hochent la tête. Vous ne vous souciez guère de savoir qui ou quoi est à l'origine de cette croisade entre le nord et le sud, si ce n'est que le %companyname% va pouvoir gagner pas mal d'argent dans cette affaire grossière. | L'arsenal assemblé devant vous est différent de tout ce que vous avez pu voir. Des armes empilées plus haut que trois hommes de la tête aux pieds. Les soldats sont alignés, la moitié d'entre eux tenant des bannières religieuses, chacune ornée d'un des anciens dieux. Des clercs et des moines marchent le long des lignes, parlant sur un ton à la fois terrestre et céleste. C'est la croisade, la grande arrestation religieuse des nordiques pour s'en prendre aux partisans du Doreur.%SPEECH_ON%Escrimeur, es-tu ? %SPEECH_OFF%Vous vous retournez pour voir un jeune garçon qui se prépare.%SPEECH_ON%Vous serez sur le droit chemin, je le sais, et les vieux dieux veilleront sur nous tous. Fais leur bien, petit scapegrave.%SPEECH_OFF%Bien sûr. Mais d'abord, tu dois bien faire les choses pour le %companyname% et obtenir une grosse bourse de toute l'action à venir.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La guerre est à nos portes.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_holywar_start"))
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;
			local town;

			foreach( t in towns )
			{
				if (t.isSouthern())
				{
					continue;
				}

				if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
				{
					nearTown = true;
					town = t;
					break;
				}
			}

			if (!nearTown)
			{
				return;
			}

			this.m.Town = town;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_holywar_start");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

