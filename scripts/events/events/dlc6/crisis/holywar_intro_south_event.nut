this.holywar_intro_south_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_intro_south";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%SPEECH_START%Que nos chemins soient dorés dans les jours à venir.%SPEECH_OFF% Le prêtre parle fort à sa congrégation.%SPEECH_ON% Je vous demande, fidèles, où la lumière est la plus brillante?%SPEECH_OFF% Une foule de paysans murmurent entre eux. Finalement, le prêtre lève la main.%SPEECH_ON% C'est à l'horizon, en luttant contre l'ombre de la terre elle-même, que nous trouvons la lueur du doreur la plus féroce. Et nous nous battons maintenant contre l'ombre, et l'horizon n'est pas la terre, mais les corruptions de la souche du Nord qui osent profaner les terres saintes!%SPEECH_OFF%La foule, autrefois confuse, est soudainement unifiée, semblant trop bien connaître la guerre de religion. Le prêtre sourit. %SPEECH_ON%C'est vrai, je vois déjà vos cœurs brûler du feu du doreur ! Nous devons défendre les lieux sacrés coûte que coûte !%SPEECH_OFF%De nouveau, la foule hurle. Vous ne savez pas trop quoi penser des peuples eux-mêmes, mais s'il y a une chose que vous savez de la guerre, c'est qu'elle est bonne pour les affaires et qu'un peu de fureur sacrée pourrait la rendre encore meilleure. | Le Vizir a fait une rare apparition pour la plèbe de son pays, et à ses côtés se trouvent les grands conseils des villes voisines. Mais il ne parle pas. Un homme vêtu d'or s'avance à sa place. %SPEECH_ON%Le chemin de nous tous a été doré, n'est-ce pas ? %SPEECH_OFF%La foule murmure entre elle, bien que personne n'ose contredire l'affirmation du saint homme. Le prêtre continue.%SPEECH_ON%Le doreur a parlé à beaucoup d'entre nous, et nous a révélé une nouvelle menace : les nordiques, poussés par leurs soi-disant anciens dieux, ont déferlé vers le sud. Ils envisagent une croisade ! Pour venir ici, juste ici, et prendre toutes nos terres et nos lieux sacrés. Vous voyez, l'éclat du doreur nous montre le chemin, mais peut-être que pour d'autres, il est bien trop aveuglant. Ces gens du nord ne comprennent pas, mais nous leur apprendrons, et par le feu du doreur nous le ferons!%SPEECH_OFF%La foule s'anime et tout sentiment d'hésitation a disparu depuis longtemps. Vous vous régalez d'une charcuterie locale et vous vous demandez combien d'argent vous allez gagner dans cette guerre sainte à venir.}",
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
				if (!t.isSouthern())
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

