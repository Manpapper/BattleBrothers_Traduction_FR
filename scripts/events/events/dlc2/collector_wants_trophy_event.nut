this.collector_wants_trophy_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null,
		Reward = 0,
		Item = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.collector_wants_trophy";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_01.png[/img]{Vous parcourez les marchés de la ville, un homme en soie s\'approche. Il arbore un sourire tellement chargé de strass que les dents apparaissent à peine, et chacun de ses doigts est orné d\'une certaine lueur. | Alors que vous jetez un coup d\'œil aux marchandises du marché local, un homme étrange s\'approche. Des boules de liquides bizarres sont suspendues à sa hanche et un bois étrange remplace la plupart de ses dents. | Un tour au marché ne serait pas ce qu\'il est sans qu\'un type louche ne vous accoste. Cette fois, il s\'agit d\'un homme au visage large, dont la bouche est un piège à ours aux dents déchiquetées, et les joues hautes comme si elles étaient faites pour être des étagères. Ces caractéristiques mises à part, il se déplace comme quelqu\'un d\'important et de riche.}%SPEECH_ON%{Ah mercenaire, je vois que vous avez quelques trophées intéressants avec vous. Et si je prenais ce %trophy% pour, disons, %reward% couronnes? | C\'est un trophée intéressant que vous avez là, le %trophy%. Je vous donne %reward% de couronnes pour ça, là maintenant, de l\'argent facile! | Hmm, je vois que vous êtes du genre aventureux. Vous n\'auriez pas trouvé ce %trophy% sans un peu de jugeote. Bon, j\'ai de l\'or sur moi, et je vous en donne %reward% pour cette babiole.}%SPEECH_OFF%Vous considérez l\'offre de cet homme.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Deal.",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "Peddler";
						}
						else
						{
							this.World.Assets.addMoney(_event.m.Reward);
							local stash = this.World.Assets.getStash().getItems();

							foreach( i, item in stash )
							{
								if (item != null && item.getID() == _event.m.Item.getID())
								{
									stash[i] = null;
									break;
								}
							}

							return 0;
						}
					}

				},
				{
					Text = "Non merci.",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "Peddler";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Peddler",
			Text = "[img]gfx/ui/events/event_01.png[/img]{Le %peddler% s\'avance et vous repousse comme si vous étiez un client quelconque et non le capitaine de la compagnie. Comme deux chiens s\'aboyant l\'un sur l\'autre, il crie sur l\'acheteur, lève la main et l\'autre lui répond. Tout est si rapide et avec tant de chiffres lancés, c\'est comme si ils parlaient dans une autre langue. Après une minute, le colporteur revient.%SPEECH_ON%Très bien. Il offre maintenant %reward% de couronnes. Je vais aller voir les casseroles et les poêles, bonne chance.%SPEECH_OFF%Il vous tape sur l\'épaule et s\'en va.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Deal.",
					function getResult( _event )
					{
						this.World.Assets.addMoney(_event.m.Reward);
						local stash = this.World.Assets.getStash().getItems();

						foreach( i, item in stash )
						{
							if (item != null && item.getID() == _event.m.Item.getID())
							{
								stash[i] = null;
								break;
							}
						}

						return 0;
					}

				},
				{
					Text = "Non merci.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				_event.m.Reward = this.Math.floor(_event.m.Reward * 1.33);
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
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
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

		local stash = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Crafting) && item.getValue() >= 400)
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() == 0)
		{
			return;
		}

		this.m.Item = candidates_items[this.Math.rand(0, candidates_items.len() - 1)];
		this.m.Reward = this.m.Item.getValue();
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_peddler = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
		}

		if (candidates_peddler.len() != 0)
		{
			this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
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
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getName() : ""
		]);
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"trophy",
			this.m.Item.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Peddler = null;
		this.m.Reward = 0;
		this.m.Item = null;
		this.m.Town = null;
	}

});

