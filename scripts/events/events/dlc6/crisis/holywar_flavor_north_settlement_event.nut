this.holywar_flavor_north_settlement_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_north_settlement";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_41.png[/img]Un chariot est arrêté sur le bord de la route. Vous trouvez un homme qui regarde une grande variété de marchandises. Il se tourne vers toi et te parle : %SPEECH_ON%Ah, un vendeur. J\'imagine que tu fais partie de la guerre sainte, hein ? Eh bien, j\'espère que tu fais ce qu\'il faut pour tes dieux. Je sais que l\'argent est important, mais il y a plus dans la vie, et plus après, tu comprends ? | [img]gfx/ui/events/event_97.png[/img]Tu trouves quelques enfants qui jouent à se battre, certains habillés de vêtements amples comme on en trouve dans les déserts du sud. Ces derniers tombent facilement sous les coups de l\'épée du dressage plus nordique.%SPEECH_ON%Ah-ha ! Les dorés tombent, et que les vieux dieux prennent la gloire que nous avons à donner!%SPEECH_OFF%Les enfants se calment et reprennent leurs positions. Cette fois, ils changent de garde, chacun échangeant ses vêtements jusqu\'à ce que les méchants deviennent des gentils et que le jeu reprenne. La guerre sainte du futur ne manquera pas de combattants fidèles, c\'est certain. | [img]gfx/ui/events/event_40.png[/img]Tu tombes sur un moine qui lit un parchemin. Il déclare que les anciens dieux ont voulu la victoire du Nord, et que la gloire sera partagée dans terraria et plus encore. Vous demandez ce qui se passe si le Nord perd. C\'est une question effrontée, certes, mais il la prend au menton avec un sourire.%SPEECH_ON%Ne vous trompez pas, marchand d\'arme, en pensant que notre guerre sainte d\'aujourd\'hui est tout ce qu\'il y aura. Ces guerres continueront jusqu\'à une fin évidente, et c\'est à cette fin que nous trouverons le plus de gloire. Je prie pour vivre pour le voir, mais mon père et son père ont prié de même, et hélas je crois que ce sera mon fils qui verra la guerre sainte menée à sa juste fin}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Si vous le dites..",
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

		if (this.World.FactionManager.isHolyWar())
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;

			foreach( t in towns )
			{
				if (!t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 5 && t.isAlliedWithPlayer())
				{
					nearTown = true;
					break;
				}
			}

			if (!nearTown)
			{
				return;
			}

			this.m.Score = 10;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

