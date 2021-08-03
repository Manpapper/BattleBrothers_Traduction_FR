this.enter_unfriendly_town_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.enter_unfriendly_town";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Les {habitants | citoyens | paysans | profanes | citadins} de %townname% acceuillent avec {quelques œufs pourris lancés avec une telle vélocité et une telle précision que l\'on ne peut s\'empêcher de penser que ces personnes n\'apprécient guère votre présence. | une poupée de goudron et de plumes se balançant d\'un arbre proche. Son visage est remarquablement similaire au vôtre, mais vous ne considérez cela que comme une coïncidence. | quelques enfants turbulents, sans doute lâchés par leurs parents pour faire des méfaits qui, dans le monde des adultes, auraient suscité une réaction violente. Alors que les petits avortons vous poursuivent en semant le chaos, vous ordonnez à vos hommes de mettre leurs bottes au travail. Quelques bons coups de pied et de poing font fuir les bâtards, mais pour combien de temps ? | une effigie en feu à votre effigie. Les paysans la trempent dans une auge à cochons. Ils se tiennent autour, s\'assurant que vous ne pouvez pas voir ce qui reste du bois sculpté.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je ne supporte pas cette ville.",
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

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer() && t.getFactionOfType(this.Const.FactionType.Settlement).getPlayerRelation() <= 35)
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

