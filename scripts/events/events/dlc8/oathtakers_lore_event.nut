this.oathtakers_lore_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null,
		Town = null,
		Replies = [],
		Results = [],
		Texts = []
	},
	function create()
	{
		this.m.ID = "event.oathtakers_lore";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Texts.resize(4);
		this.m.Texts[0] = "Speak about Oaths.";
		this.m.Texts[1] = "Speak about Young Anselm.";
		this.m.Texts[2] = "Speak about those pieces of shite.";
		this.m.Texts[3] = "We\'ve said everything there is to say.";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%townname%\'s people are happy to see the %companyname%. It is an unusual reception for a band of mercenaries, but it seems the Oathtaking aspects of your business are held in high esteem with the laity.%SPEECH_ON%It\'s about time someone brought honor and pride back to these lands.%SPEECH_OFF%One peasant says. Women adorn you with flowers and other good graces. As you bring the wagon to a stop, a throng of children come up wanting to touch Young Anselm\'s skull.%SPEECH_ON%Will it give us strength? Or will it make me sick?%SPEECH_OFF%Another kid comes up and elbows him out of the way.%SPEECH_ON%Just have \'im tell us what they do and are already! Oaths, this here skull, and the other day we heard about Oathbringers, so what makes ye so different?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B0",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Hand to Anselm\'s head, you explain the Oaths.%SPEECH_ON%Every day that we rise and offer ourselves unto this world, we take an oath. An oath to ourselves, to our loved ones, to our neighbors, even to the earth, and to the animals which adorn it. We take an oath to the world entire.%SPEECH_OFF%A kid bites down on an apple. He says.%SPEECH_ON%If ever\'one is takin\' oaths, what makes you the Oathtakers? Aren\'t we all Oathtakers then?%SPEECH_OFF%You grin and nod.%SPEECH_ON%Precisely. We are all Oathtakers indeed. However, if I may let you in on a little secret...%SPEECH_OFF%The kids gather around, hushing one another. You explain.%SPEECH_ON%When you were born, you did not know all, yes? Same as our oaths. The old gods wish us to explore this world in full, not have all its mysteries merely handed to us. If they were handed to us, would we be where we are today? Or would our contentedness leave us in our first dwellings? We, Oathtakers, are exploring the extent to which the old gods have strengthened us, and also weakened us, and in seeking all our limits we shall become closer with the old gods, and closer with all others.%SPEECH_OFF%One of the kids kicks dirt. He asks if you have any sweet pies in that there wagon.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[0] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You tap Young Anselm\'s skull.%SPEECH_ON%Young Anselm was the First Oathtaker, the beginning of the Oathtakers. He was the first to realize that the true nature of man required sacrifice. He believed, and rightly so, that when man first wandered the earth, he did so in a state of suffering, and it was in that being that he made his greatest advances. What we have now is so very far away from how things were. Things are simply too good now.%SPEECH_OFF%One of the kids scratches off a black scab and flicks it onto the face of another. The other kid wipes it away and pops a pustule and rubs the pus all over the other kid. While they quarrel, you continue on.%SPEECH_ON%Young Anselm realized this world needed to return to a life of sacrifice, to give up elements of what you enjoy, to sharpen oneself against the grindstone of suffering. Naturally, this made Young Anselm many enemies.%SPEECH_OFF%One of the kids looks up and asks how it was that Young Anselm died. You smile and say that is a story for another time.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[1] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_97.png[/img]{One of the kids pipes up.%SPEECH_ON%We had a group of men like you in town the other day. Said they were the \'Oathbringers.\' Are they like yer brothers or somethin\'?%SPEECH_OFF%You start to answer when %oathtaker% butts in.%SPEECH_ON%The Oathbringers are blasphemers! They are heathens, and not keepers of oaths, but breakers of them! They have stolen Young Anselm\'s jawbone, and we vow slay every Oathbringer to have it returned.%SPEECH_OFF%The boy says that the Oathbringers said they were wanting to get the skull from you, because you, the Oathtakers, were the true heathens. %oathtaker%\'s anger reaches a boiling point.%SPEECH_ON%The Oathbringers say a lot of shite! They are peddlers of lies, nonsense and hysteria for a storefront, and cruel misapprehensions their goods!%SPEECH_OFF%You stare at the Oathtaker for a while, then put a hand on his shoulder and tell him maybe he should go count inventory to cool down for a bit.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[2] = true;
				_event.addReplies(this.Options);
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 3; i = ++i )
		{
			if (!this.m.Replies[i])
			{
				local result = this.m.Results[i];
				_to.push({
					Text = this.m.Texts[i],
					function getResult( _event )
					{
						return result;
					}

				});
				n = ++n;

				if (n >= 4)
				{
					break;
				}

				  // [034]  OP_CLOSE          0      4    0    0
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = $[stack offset 0].m.Texts[3],
				function getResult( _event )
				{
					return 0;
				}

			});
		}
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
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

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
			{
				haveSkull = true;
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (!haveSkull)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
		this.m.Replies = [];
		this.m.Replies.resize(3, false);
		this.m.Results = [];
		this.m.Results.resize(3, "");

		for( local i = 0; i < 3; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
		this.m.Town = null;
	}

});

