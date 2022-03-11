this.oathtaker_joins_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.oathtaker_joins";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{A man in armor approaches the company. He seems most usual, until he opens his mouth.%SPEECH_ON%Hear ye, hear ye, I am a proud Oathtaker! Now, I see you also have what appears to be a high regard for doing what is right. That makes me believe you, too, are Oathtakers. So! I have but one question for you: that skull hanging from a necklace, what is his name? If it is the one I seek, then ye shall have my hand.%SPEECH_OFF% | Men in armor are not a rare sight on the roads these days, but this man has a certain level of pomp and theatrics that draws the eye, as does the fact he confidently strides right over to you.%SPEECH_ON%I\'d been carousing at a local pub when I got word that a band of Oathtakers had been passing through these lands. Now, either that is some graveyard skullduggery hanging from yer neck, or that is...well, you tell me. Give me the right name of that skull and I\'ll join you right here and now.%SPEECH_OFF% | You come across a man in armor. He stands in the road like he either wants to commit suicide by sellsword, or he\'s looking to risk his neck for a coin. As you draw near, he waves you down.%SPEECH_ON%Ah, the men I am looking for. Are you with the Oathtakers? I wish to join you on the path. The path of...%SPEECH_OFF%He pauses, gesturing toward the company\'s resident skull. Oh, he means... | A man in armor hurries out onto the road. You put a hand to your sword, but he simply bows as though you were an executioner.%SPEECH_ON%I prayed to the old gods to harden my virtues and keep me on the path. Surely, stranger, surely that is his skull there hanging from your neck? If it is, I shall join you and the oaths you\'re on this very minute. Please, tell me, is that the jawless skull of our dear...our...%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Young Anselm.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Hugo.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"paladin_background"
				]);
				local dudeItems = _event.m.Dude.getItems();

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Head) != null && dudeItems.getItemAtSlot(this.Const.ItemSlot.Head).getID() == "armor.head.adorned_full_helm")
				{
					dudeItems.unequip(dudeItems.getItemAtSlot(this.Const.ItemSlot.Head));
					dudeItems.equip(this.new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Body) != null && dudeItems.getItemAtSlot(this.Const.ItemSlot.Body).getID() == "armor.body.adorned_heavy_mail_hauberk")
				{
					dudeItems.unequip(dudeItems.getItemAtSlot(this.Const.ItemSlot.Body));
					dudeItems.equip(this.new("scripts/items/armor/adorned_warriors_armor"));
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_180.png[/img]{The man drops to a knee, his head down.%SPEECH_ON%Truly, Young Anselm has guided me here! I shall join you on the path, fellow Oathtakers!%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Welcome aboard.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_180.png[/img]{The man sighs.%SPEECH_ON%Ah, I see now. There are far too many Hugos in this world, it does not surprise me that yet another has appeared in such a state as that dreary skull, though I know not why you carry it around like so.%SPEECH_OFF% | %SPEECH_ON%Hugo.%SPEECH_OFF%The man says.%SPEECH_ON%Another farkin\' Hugo, huh? How many are out here? Every other man I run into is a Hugo.%SPEECH_OFF%He turns and walks off, mumbling angrily about the commoners and their unoriginal naming schemes. | The man sighs.%SPEECH_ON%Hugo, huh? Alright. Whelp, see you later.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Good luck out there.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
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

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.getTime().Days <= 30)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local numOathtakers = 0;
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				numOathtakers++;
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

		local comebackBonus = numOathtakers < 2 ? 8 : 0;
		this.m.Score = 2 + comebackBonus;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

