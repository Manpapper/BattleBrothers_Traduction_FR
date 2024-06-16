this.inadvertently_save_merchant_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.inadvertently_save_merchant";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 130.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%En vous promenant dans %townname% avec quelques mercenaires, vous tournez à un coin pour trouver un homme opulent entouré de voleurs et de bandits. Ils regardent par-dessus leurs épaules et écarquillent les yeux. L\'un d\'eux pique le marchand sur la joue.%SPEECH_ON%Très bien, on t\'aura la prochaine fois salaud !%SPEECH_OFF%Les scélérats s\'en vont rapidement. Un instant plus tard, les gardes du marchand, lourdement armés, apparaissent. En soignant sa blessure, il commence à leur hurler dessus.%SPEECH_ON%Pourquoi je vous paye, bande de bons à rien ? Dès que j\'ai des problèmes, vous n\'êtes pas là ? Regardez cet homme, c\'est lui que je devrais payer ! Hé, prends ça pour tes ennuis, étranger. Le marchand te lance une sacoche de couronnes pour tes \"ennuis\", alors que tu n\'as fait que tourner au coin de la rue et tomber sur une coïncidence.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Eh bien, pourquoi pas.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(25);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]25[/color] Couronnes"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() <= 1 || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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

