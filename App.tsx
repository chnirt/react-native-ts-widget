/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React, {useState} from 'react';
import {StyleSheet, View, TextInput, NativeModules} from 'react-native';
import SharedGroupPreferences from 'react-native-shared-group-preferences';

const group = 'group.asap';

const SharedStorage = NativeModules.SharedStorage;

const App = () => {
  const [text, setText] = useState('');
  const widgetData = {
    text,
  };

  const handleSubmit = async () => {
    try {
      // iOS
      await SharedGroupPreferences.setItem('widgetKey', widgetData, group);
    } catch (error) {
      console.log({error});
    }
    // Android
    SharedStorage.set(JSON.stringify({text}));
  };

  return (
    <View style={styles.container}>
      <TextInput
        style={styles.input}
        onChangeText={newText => setText(newText)}
        value={text}
        returnKeyType="send"
        onEndEditing={handleSubmit}
        placeholder="Enter the text to display..."
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginTop: '50%',
    paddingHorizontal: 24,
  },
  input: {
    width: '100%',
    borderBottomWidth: 1,
    fontSize: 20,
    minHeight: 40,
  },
});

export default App;
