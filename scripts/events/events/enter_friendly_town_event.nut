this.enter_friendly_town_event <- this.inherit("scripts/events/event", {quelques demandes en mariage que vous ne pouvez pas refuser assez vite.
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.enter_friendly_town";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]{Votre arrivée à %townname% semble être une raison de faire la fête. L\'un des conseillers municipaux vous salue et vous offre des rafraîchissements. | %townname% montre sa reconnaissance pour votre travail en vous offrant, à vous et à vos hommes, un plateau de rafraîchissements. %randombrother% fait claquer quelques chopes sous le regard émerveillé d\'une serveuse délicate et féminine. Il s\'essuie la bouche.%SPEECH_ON%Merci à vous. Plus, s\'il vous plaît.%SPEECH_OFF% | Les affaires à %townname% ont été bonnes et les habitants semblent vous apprécier de plus en plus : en arrivant aujourd\'hui, ils vous ont donné {beaucoup de remerciements inutiles | une tempête de gratitude | des fleurs dont vous n\'avez que faire | des babioles et autres choses que l\'on jette quand les paysans ne regardent pas | un plateau de bière que vos hommes consomment rapidement | un tonneau de bière que vos hommes critiquent sans délicatesse comme ayant \"un goût de bois\" | quelques demandes en mariage que vous refusez gentiment | quelques demandes en mariage que vous ne pouvez pas refuser assez vite | une demande en mariage de la mocheté de la ville. Elle a un visage qui pourrait rendre aveugle. Vous déclinez l\'offre | une célébration rapide où quelques personnes ont crié de façon incohérente. Leur ton semblait joyeux, en tout cas | quelques tapes dans le dos. Vous leur rappelez qu\'une telle action pourrait les laisser sans mains la prochaine fois | une offrande d\'orphelins. Vous n\'avez aucune idée de ce qui leur a donné l\'idée que vous accepteriez un tel cadeau, mais vous renvoyez les enfants dans leur triste foyer, aussi connu sous le nom de rues}.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Toujours agréable d\'être à %townname%.",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local town;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer() && t.getFactionOfType(this.Const.FactionType.Settlement).getPlayerRelation() > 80)
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
		this.m.Score = 15;
	}

	function onPrepare()
	{
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

